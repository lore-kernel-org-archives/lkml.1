Return-Path: <linux-kernel-owner+w=401wt.eu-S932375AbZACHbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932375AbZACHbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 02:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753168AbZACHbT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 02:31:19 -0500
Received: from 1wt.eu ([62.212.114.60]:1069 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532AbZACHbO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 02:31:14 -0500
Date: Sat, 3 Jan 2009 08:30:51 +0100
From: Willy Tarreau <w@1wt.eu>
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel@vger.kernel.org, Steven Noonan <steven@uplinklabs.net>,
       Dave Jones <davej@redhat.com>
Subject: Re: ath9k microwave anomaly
Message-ID: <20090103073051.GC5038@1wt.eu>
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com> <495EDC10.20605@gmail.com> <f488382f0901021949y60b6d60fjeaeb6bb12a851f8@mail.gmail.com> <495EE2A0.2080703@gmail.com> <495EEE1D.8050500@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <495EEE1D.8050500@shaw.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:48:29PM -0600, Robert Hancock wrote:
> Justin P. Mattock wrote:
> >Steven Noonan wrote:
> >>On Fri, Jan 2, 2009 at 7:31 PM, Justin P. Mattock
> >><justinmattock@gmail.com> wrote:
> >> 
> >>>Dave Jones wrote:
> >>>   
> >>>>On Fri, Jan 02, 2009 at 06:47:32PM -0800, Justin P. Mattock wrote:
> >>>> > Now I'm not trying to be funny,
> >>>> > but I think I figured a problem
> >>>> > with running ath9k, and having the internet
> >>>> > timeout.(for me at least);
> >>>> > When streaming T.V.(cspan2), and
> >>>> > streaming music(somafm), at the same time,
> >>>> > then using the microwave, I'll experience a blackout
> >>>> > of internet(T.V. stops, then music stops streaming);
> >>>>
> >>>>not specific to ath9k.
> >>>>
> >>>>http://blogs.zdnet.com/Ou/?p=578 has some pretty graphics
> >>>>to show just how much noise a microwave puts into the part
> >>>>of the spectrum wifi uses.
> >>>>
> >>>>       Dave
> >>>>
> >>>>
> >>>>      
> >>>Damn that's allot,
> >>>no wonder I was having these timeouts.
> >>>i.g. system streams fine for 10 hours.
> >>>then the next day a timeout after 2 hours due
> >>>to microwave use.
> >>>Thanks for pointing that blog out.
> >>>that opened my eyes up to how powerful
> >>>a microwave is. makes me wonder if that
> >>>grade in the window actually does what is supposed to.
> >>>(block gamma rays or whatever the dangerous wave is);
> >>>
> >>>regards;
> >>>
> >>>Justin P. Mattock
> >>>
> >>>    
> >>Yeah, I think it was Luis Rodriguez (from Atheros) who told me that a
> >>microwave was the best way to make a signal "wet poop" for
> >>interference testing.
> >>
> >>  
> >Well, this one here seems to be not
> >that old, but it's enough to cause
> >interference. Hopefully not too old
> >to cause me to go sterile!!
> >interesting thing is when
> >the microwave is cold and then started
> >I noticed more interference, as to when
> >it's been running for a while.
> 
> I think the standards for microwaves allow a reasonable amount of 
> microwave leakage - still way below the levels that can harm you, but 
> compared to the power levels that a WiFi device puts out, it's pretty 
> significant..

BTW, having any WiFi stopping working at 30 feet around a microwave oven
makes me think that beast is leaking like mad. I've already ran experiences
with mine in the past, and it could only slightly perturbate the traffic
within one meter (3 ft) which I already considered huge. You may want to
try to put some aluminium foil on the front door, it is possible that the
protection grid is damaged or not properly sealed.

Willy

