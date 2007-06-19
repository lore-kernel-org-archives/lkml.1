Return-Path: <linux-kernel-owner+w=401wt.eu-S932412AbXFSALk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbXFSALk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 20:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764274AbXFSALX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 20:11:23 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37470 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763801AbXFSALW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 20:11:22 -0400
Date: Mon, 18 Jun 2007 17:09:37 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Martin Bligh <mbligh@mbligh.org>
cc: Natalie Protasevich <protasnb@gmail.com>,
       "Fortier,Vincent [Montreal]" <Vincent.Fortier1@ec.gc.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Adrian Bunk <bunk@stusta.de>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>, Andi Kleen <andi@firstfloor.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: How to improve the quality of the kernel?
In-Reply-To: <46771C5D.10809@mbligh.org>
Message-ID: <alpine.LFD.0.98.0706181706470.3593@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org>
  <200706172053.41806.bzolnier@gmail.com>  <20070617115258.1f55b29d.akpm@linux-foundation.org>
  <200706172349.08813.bzolnier@gmail.com>  <4675C083.6080409@s5r6.in-berlin.de>
  <20070617220927.99ebc1ee.akpm@linux-foundation.org> 
 <F1D642E5A91BC94D9504EC83AE19E6B0128A0D@ecqcmtlmail3.quebec.int.ec.gc.ca> 
 <32209efe0706181531x5322533dr31dc90e6dd8c7973@mail.gmail.com> 
 <46770A22.4020007@mbligh.org> <32209efe0706181556l2ed378f4sf520c3852f398fa4@mail.gmail.com>
 <46771C5D.10809@mbligh.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 18 Jun 2007, Martin Bligh wrote:
> 
> Sorry to be a wet blanket, but I've seen those sort of things
> before, and they just don't seem to work, especially in the
> environment we're in with such a massive diversity of hardware.

I do agree. It _sounds_ like a great idea to try to control the flow of 
patches better, but in the end, it needs to also be easy and painfree to 
the people involved, and also make sure that any added workflow doesn't 
require even *more* load and expertise on the already often overworked 
maintainers..

In many cases, I think it tends to *sound* great to try to avoid 
regressions in the first place - but it also sounds like one of those "I 
wish the world didn't work the way it did" kind of things. A worthy goal, 
but not necessarily one that is compatible with reality.

			Linus
