Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbXGUTid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbXGUTid (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 15:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759450AbXGUTi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 15:38:26 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:50621 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756299AbXGUTiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 15:38:25 -0400
X-Originating-Ip: 72.143.66.27
Date: Sat, 21 Jul 2007 15:36:31 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use menuconfig objects - Fusion
In-Reply-To: <Pine.LNX.4.64.0707212135060.21737@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0707211536140.8335@localhost.localdomain>
References: <200705102317.l4ANHrUC001117@shell0.pdx.osdl.net>
 <Pine.LNX.4.64.0707182035080.5385@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707211501570.5853@localhost.localdomain>
 <Pine.LNX.4.64.0707212112060.21737@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0707211513170.6770@localhost.localdomain>
 <Pine.LNX.4.64.0707212135060.21737@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 Jul 2007, Jan Engelhardt wrote:

>
> On Jul 21 2007 15:15, Robert P. J. Day wrote:
> >> >wouldn't it be philosophically cleaner if the internals of a
> >> >menuconfig structure *automatically* depended on selection of the
> >> >menuconfig and the "if" part was implicit?
> >>
> >> "menuconfig" is not a start marker like "menu" was. Hence it has no
> >> "stop" marker either. We would need a new object type for that.
> >
> >http://www.linuxrocket.net/index.cgi?a=MailArchiver&ma=ShowMail&Id=525787
>
> Exactly like that. But kconfig don't have selectablemenu (yet).

well, fine ... i'll see what i can do.  :-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
