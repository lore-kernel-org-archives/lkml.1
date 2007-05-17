Return-Path: <linux-kernel-owner+w=401wt.eu-S1761192AbXEQDDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192AbXEQDDn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758692AbXEQDDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:03:36 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37737 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758502AbXEQDDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:03:35 -0400
X-Sasl-enc: q6YT5VY2RgVik0ilRXH+Q6iBIHVtfNWjykknV6Hht9KO 1179371016
Date: Thu, 17 May 2007 00:03:30 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: George Nychis <gnychis@cmu.edu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dock support on thinkpad x60s for DVD/CDROM
Message-ID: <20070517030330.GA20892@khazad-dum.debian.net>
References: <464BB172.2040502@cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <464BB172.2040502@cmu.edu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007, George Nychis wrote:
> I was wondering if any progress was made on the docking station support for new thinkpads,
> like the x60s ultradock.  I'm looking for support for the CD/DVD burner on it.  I tried
> enabling the most recent dock support in the kernel and still nothing. (2.6.22-rc1)

ACPI generic dock driver, or thinkpad-acpi dock driver?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
