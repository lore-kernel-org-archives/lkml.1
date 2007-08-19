Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbXHSMa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbXHSMa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 08:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751465AbXHSMaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 08:30:18 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:58161 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbXHSMaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 08:30:17 -0400
X-Originating-Ip: 72.143.66.27
Date: Sun, 19 Aug 2007 08:22:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Joe Perches <joe@perches.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: tracking MAINTAINERS versus tracking SUBSYSTEMS
In-Reply-To: <1187483578.4200.51.camel@localhost>
Message-ID: <Pine.LNX.4.64.0708190818280.7224@localhost.localdomain>
References: <Pine.LNX.4.64.0708181311490.10387@localhost.localdomain>
 <1187483578.4200.51.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2007, Joe Perches wrote:

> On Sat, 2007-08-18 at 13:35 -0400, Robert P. J. Day wrote:
> >   $ show_subsystem drivers/bluetooth/bpa10x.c
> >   BLUETOOTH
>
> "what's a subsystem"? I'm not sure there is an appropriate
> definition. If there is an appropriate definition, why should anyone
> care what subsystem a particular file is in?

i'm confused -- i thought that was sort of the whole purpose of this
exercise, to match parts of the kernel source tree against the
maintainer for those parts, and to do that via the defined
"subsystem" which is currently used in MAINTAINERS.

you can, of course, banish the concept of a subsystem entirely and
work purely from a file and directory perspective, but i think the
notion of the kernel tree being composed of subsystems is a useful
idea.  that's just my opinion, though.

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
