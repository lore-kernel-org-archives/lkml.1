Return-Path: <linux-kernel-owner+w=401wt.eu-S1754388AbYFLCSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbYFLCSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 22:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752695AbYFLCSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 22:18:09 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:37234 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752693AbYFLCSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 22:18:08 -0400
X-Sasl-enc: Yw6VuzrP3Ec/GQTbcQPpqWALwTOvfcyYYLtLfwOqUqdV 1213237085
Date: Wed, 11 Jun 2008 23:18:02 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Pavel Machek <pavel@suse.cz>
Cc: "Renato S. Yamane" <yamane@diamondcut.com.br>,
       linux-kernel@vger.kernel.org, devzero@web.de
Subject: Re: [Bug 10797] Something is consuming power after shutdown
Message-ID: <20080612021801.GB2418@khazad-dum.debian.net>
References: <483AB443.6020807@diamondcut.com.br> <20080531074433.GE5405@ucw.cz> <4842BB89.5090908@diamondcut.com.br> <20080602192012.GA7748@ucw.cz> <4846744A.9040204@diamondcut.com.br> <484D10DE.30704@diamondcut.com.br> <20080611103330.GA5612@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611103330.GA5612@ucw.cz>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jun 2008, Pavel Machek wrote:
> > If I hold power button to force shutdown I don't have this problem with
> > battery charge.
> 
> Too bad, I can't call the hw terminally broken, then.

No, just the ACPI firmware :-)

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
