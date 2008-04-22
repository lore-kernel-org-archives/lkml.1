Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbYDVG7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbYDVG7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 02:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754929AbYDVG72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 02:59:28 -0400
Received: from fmmailgate04.web.de ([217.72.192.242]:43051 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896AbYDVG72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 02:59:28 -0400
Date: Tue, 22 Apr 2008 08:59:26 +0200
Message-Id: <248793158@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [2.6 patch] remove the v850 port
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX185rjjwnYLvO2+PtQ8D24hWCANvkUbdEsLG62DS2/xdEJ1PD
 r/2V7HXNbEPPiJC2PQZdpuRz2Kyhib4N4lwpOww5yUyLslZAN8=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sounds reasonable, thanks for explaining.
indeed this is an exceptional case and when there was a timeslot for adding to feature-removal-schedule.txt, then that was 3 months (or even more) ago.

thanks
roland

> -----Ursprüngliche Nachricht-----
> Von: "Adrian Bunk" <bunk@kernel.org>
> Gesendet: 22.04.08 02:01:20
> An: devzero@web.de
> CC: linux-kernel@vger.kernel.org, mingo@elte.hu
> Betreff: Re: [2.6 patch] remove the v850 port


> On Tue, Apr 22, 2008 at 01:38:49AM +0200, devzero@web.de wrote:
> > I can't afford to be critical here, but let me give a comment.
> > 
> > i think putting this in feature-removal-schedule.txt just good practice.
> > you give people the chance to catch up - sort of a last reminder to the devs "fix it or we need to drop it".
> > some chance for the users to see it will go away and make early decision based on that.
> > 
> > i like those cleanup efforts, but even if it was announced on lkml, or elsewhere - that file is the official place for such announcements and if you want people take care of that file, there should be reliable information inside. 
> > 
> > it often takes much effort and hard work to get code into the kernel, so some "nah, this is broken, doesn`t compile for long - put that to trash" seems a little bit harsh for me.
> > 
> > the reason why it`s broken is probably not the v850 people`s fault. 
> > ok, they just didn`t catch up with that "kernel progress" - but most probably some other person broke their code.
> > 
> > i don`t like bureaucracy, but a little bit of bureaucracy at the right place is not that bad at all.....
> 
> As the patch description says it does not even compile since at
> least kernel 2.6.19 (which was released in 2006).
> 
> I've sent this removal patch 7 times during 3 months to linux-kernel.
> 
> Before that I sent 2 emails to linux-kernel asking about the status of 
> the port.
> 
> All emails also got to Miles, the maintainer of the port.
> 
> Without the slightest sign of anyone claiming he might work on fixing 
> this port.
> 
> Greg (one of the uClinux core maintainers) said the only one he knows 
> who can maintain the port is Miles.
> 
> If there's not a single person on linux-kernel who is either interested 
> in this port or at least knows someone who is, then requiring to put it 
> into some file in the kernel sources is actually quite high on the scale 
> of pointless bureaucracy.
> 
> > roland
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 
> 


_______________________________________________________________
Schon gehört? Der neue WEB.DE MultiMessenger kann`s mit allen: 
http://www.produkte.web.de/messenger/?did=3016

