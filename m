Return-Path: <linux-kernel-owner+w=401wt.eu-S932950AbXDJDsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932950AbXDJDsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 23:48:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932997AbXDJDsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 23:48:20 -0400
Received: from vms046pub.verizon.net ([206.46.252.46]:45103 "EHLO
	vms046pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932969AbXDJDsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 23:48:18 -0400
Date: Mon, 09 Apr 2007 23:47:57 -0400
From: Gene Heskett <gene.heskett@gmail.com>
Subject: Re: I give up
In-reply-to: <20070410012754.GD1994@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jones <davej@redhat.com>, Dave Dillow <dave@thedillows.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Message-id: <200704092347.57433.gene.heskett@gmail.com>
Organization: Organization? very little
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7bit
Content-disposition: inline
References: <200704091007.58535.gene.heskett@gmail.com>
 <1176157330.4767.12.camel@dillow.idleaire.net>
 <20070410012754.GD1994@redhat.com>
User-Agent: KMail/1.9.6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2007, Dave Jones wrote:
>On Mon, Apr 09, 2007 at 06:22:10PM -0400, Dave Dillow wrote:
> > On Mon, 2007-04-09 at 23:35 +0200, Jan Engelhardt wrote:
> > > On Apr 9 2007 15:38, Gene Heskett wrote:
> > > >On Monday 09 April 2007, H. Peter Anvin wrote:
> > > >>Jan Engelhardt wrote:
> > > >>> dm is on 254 for me.. in opensuse with a 2.6.20 that is. I
> > > >>> wonder why it even moves around. However, even then, those who
> > > >>> use udev and device names rather than (major,minor) tuples
> > > >>> should not have any problem.
> > > >>
> > > >>It moves around because someone at some point thought it was a
> > > >> great idea to assign dynamic majors to core functionality.
> > > >
> > > >What were they smoking, I want some of that!
> > >
> > > Do you actually use udev?
> >
> > udev doesn't help the problem he is having (and he is using it, since
> > he is using Fedora).
>
>However, it also doesn't explain what the point is of backing up /dev
>when it's dynamically created.
>
>	Dave

I'm glad you mentioned that, I was, leftovers from RH7.3 probably. :(

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Windows Tip of the Day:
Add DEVICE=FNGRCROS.SYS to your CONFIG.SYS file.
