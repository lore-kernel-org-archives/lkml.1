Return-Path: <linux-kernel-owner+w=401wt.eu-S1751856AbXDKJsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856AbXDKJsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 05:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbXDKJsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 05:48:15 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:60782 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXDKJsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 05:48:14 -0400
X-Originating-Ip: 74.109.98.130
Date: Wed, 11 Apr 2007 05:47:00 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: "menu" versus "menuconfig" -- they're *both* a bad idea
In-Reply-To: <Pine.LNX.4.61.0704111134300.32056@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0704110546220.11664@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0704110357200.9384@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704111059190.32056@yvahk01.tjqt.qr>
 <Pine.LNX.4.64.0704110509200.11343@CPE00045a9c397f-CM001225dbafb6>
 <Pine.LNX.4.61.0704111134300.32056@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Apr 2007, Jan Engelhardt wrote:

>
> On Apr 11 2007 05:25, Robert P. J. Day wrote:
> >On Wed, 11 Apr 2007, Jan Engelhardt wrote:
> >> On Apr 11 2007 03:58, Robert P. J. Day wrote:
> >>
> >> A CONFIG_EMBEDDED bug. This should perhaps be changed.
> >> Or at best, deactivate the ---> part when it's N.
> >
> >  i'm not sure what you mean by "bug".  if what you mean is that it's
> >a bad choice of menu layout, i agree.  but what's happening there
> >is not technically "wrong" or "buggy" in the sense that it's
> >perfectly legal based on the current design of "menuconfig".
>
> Of course.

ok, just checking that we were actually agreeing with one another.
:-)

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
