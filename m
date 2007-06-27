Return-Path: <linux-kernel-owner+w=401wt.eu-S1761226AbXF0M7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761226AbXF0M7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758820AbXF0M6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:58:53 -0400
Received: from web52505.mail.re2.yahoo.com ([206.190.48.188]:45485 "HELO
	web52505.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759351AbXF0M6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:58:52 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Fvj7xBwdiZw2AbmIs/+Fw1bsAUfNTFc9XemUXoeKFQNidlZhvWATMSFbMODXMcpQisk4YVmmae2d2SA+MtcEU7ffiNHUUzC50KMaXzmgZ2D9lL25U4miB3jOAoDu0v1lUtWIycoFWemZpWPG3EFVieu+a5+E1D5kXfsg+AKdgC0=;
X-YMail-OSG: DhFGdrAVM1mOaQPn9RzypY7L2vah.m6qHe7aWZmiIEUfNoLKpsh54zj1kNPVJzMnJEW7FqvFHFOLFJd.r9AVEdESf3D_5NWI3X15gETfsQDsWCad8CQCOO9oRPGe
Date: Wed, 27 Jun 2007 05:58:51 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: NVidia Driver Support - 1680x1050 mode
To: Kyle Moffett <mrmacman_g4@mac.com>,
       Daniel J Blueman <daniel.blueman@gmail.com>
Cc: Marc Perkel <mperkel@yahoo.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1090CBC0-91B3-49EC-9A69-4864201CA967@mac.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <698083.6027.qm@web52505.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Kyle Moffett <mrmacman_g4@mac.com> wrote:

> Marc, please choose a more appropriate list next
> time.  LKML is not  
> for user questions about "Why doesn't my monitor+GPU
> work?"
> 
> On Jun 27, 2007, at 05:49:20, Daniel J Blueman
> wrote:
> > On 27 Jun, 04:40, Marc Perkel <mperkel@yahoo.com>
> wrote:
> >> Trying to get my Asus M2NPV-VM motherboard and my
> Samsung  
> >> SyncMaster 215tw Digital to work in 1680x1050
> mode but 1280x1024  
> >> is the most I can get. Chip Set is GeForce 6150.
> >>
> >> Looking in Xorg.0.log it ssems to think that the
> panel size is  
> >> 1280x1024 in spite of my setting telling it
> differently.
> >>
> >> Sorry if this is off topic but I thought that the
> smart people  
> >> would be here. In Windows I just plug it in and
> it works. So I  
> >> figure Linux should work too. :)
> >
> > Wrong list, but anyway...
> >
> > If you're using a DVI cable, ensure it is
> dual-link.
> 
> Uhh, no;  1680x1050 does not require a dual-link DVI
> port/cable.  As  
> to a good GPU which "Just Works(TM)" out of the box
> and still has at  
> least passable render performance (although not for
> some modern  
> games),  the R200-series Radeon cards (listed below)
> work extremely  
> well.  They even support a 3d-accelerated
> merged-framebuffer Xinerama- 
> style; you can split a 3d-accelerated window across
> both monitors.
> 
> R200-series cards:
>    R200:  Radeon 8500/8500LE/9100, FireGL 8700/8800
>    rv250: Radeon 9000/9000Pro
>    rv280: Radeon 9200/9250/9200SE
> 
> More info here:
>    http://dri.freedesktop.org/wiki/ 
>
ATIRadeon#head-9161ac9470497d94f1a4f79794697347b20d5170
> 
> Cheers,
> Kyle Moffett
> 


Quite frankly, I don't understand why digital LCD
monitor even have scan rates in the first place. It's
not a CRT that actually has an electron beam. You
would thing that it would have a digital interface
where the computer told the monitor what to draw and
the monitor deals with it.



       
____________________________________________________________________________________Ready for the edge of your seat? 
Check out tonight's top picks on Yahoo! TV. 
http://tv.yahoo.com/
