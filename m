Return-Path: <linux-kernel-owner+w=401wt.eu-S1755474AbXITJ7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474AbXITJ7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 05:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750981AbXITJ7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 05:59:41 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42953 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbXITJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 05:59:40 -0400
X-Sasl-enc: Y70LFIkXj2a70F6UldUI5KbYDW69mgTYJM+5jKyeRG1p 1190282379
Date: Thu, 20 Sep 2007 06:59:35 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Peter Schwabe <schwabe@ti.rwth-aachen.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Another Hitachi Disk with NCQ problems
Message-ID: <20070920095935.GD300@khazad-dum.debian.net>
References: <46F229CF.5020109@ti.rwth-aachen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46F229CF.5020109@ti.rwth-aachen.de>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2007, Peter Schwabe wrote:
> Model number: HITACHI HTS541612J9SA00

If you got it with the thinkpad, it will have an IBM/Lenovo firmware.  Ask
them for a fix.  They might have broken NCQ while adding immediate unload
and security extensions to the original Hitachi firmware.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
