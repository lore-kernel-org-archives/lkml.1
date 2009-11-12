Return-Path: <linux-kernel-owner+w=401wt.eu-S1755048AbZKLXFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755048AbZKLXFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 18:05:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZKLXFu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 18:05:50 -0500
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:35947 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934AbZKLXFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 18:05:50 -0500
Date: Thu, 12 Nov 2009 13:18:05 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matteo Croce <technoboy85@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: i686 quirk for AMD Geode
Message-ID: <20091112121805.GF1394@ucw.cz>
References: <40101cc30910021912r17b3a08bue1b9412e4fa47d89@mail.gmail.com> <20091003072127.GC21407@elte.hu> <40101cc30911060659k7b3b6428ob1340e476bdbac5b@mail.gmail.com> <4AF4526B.4060101@zytor.com> <40101cc30911081042n93e268bs66b9436a0174a19a@mail.gmail.com> <20091109201608.GD15159@caffeine.csclub.uwaterloo.ca> <4AF886D4.1080108@zytor.com> <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109212333.GE15159@caffeine.csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The Geode NX (which no one has mentioned yet) is an Athlon derived chip.
> > 
> > *As far as I know* K6 didn't have NOPL, whereas K7 does.
> 
> Which would be mroe indication that the Geode LX may in fact be a K6
> based CPU design.  The Geode NX is very clearly an Athlon (K7) and AMD
> has never even tried to hide that.  They have never said what the LX is
> based on, other than it isn't based on the GX (fortunately, that thing
> was a buggy piece of crap).

Interesting...geode gx being buggy? I know pentium was famous for the
fdiv bug, but never heard of geode gx problems...

Are they something kernel can work around, or do those chips just have
to be avoided? Anything malicious user can use to crash the system?
Anything malicious user can use to gain extra priviledge?
								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
