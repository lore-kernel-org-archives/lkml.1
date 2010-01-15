Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0AOQVn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 11:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159Ab0AOQVn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 11:21:43 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:56091 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423Ab0AOQVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 11:21:42 -0500
Subject: Re: [PATCH] drm/i915: disable LVDS downclock by default
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Nick Bowler <nbowler@draconx.ca>, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1263572080.2217.1.camel@localhost.localdomain>
References: <alpine.LFD.2.00.1001122139411.17145@localhost.localdomain>
	 <20100113133357.67f9df6d@jbarnes-piketon> <4B4E403C.1050509@cs.helsinki.fi>
	 <20100113165530.2a7e7645@jbarnes-piketon>  <4B4F6D5F.10008@cs.helsinki.fi>
	 <20100114193118.GA1203@emergent.ellipti  <84144f021001150054m532cd1cdwbbdbab79b5924fb7@mail.gmail.com>
	 <1263572080.2217.1.camel@localhost.localdomain>
Date: Fri, 15 Jan 2010 18:21:40 +0200
Message-Id: <1263572500.13459.6.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Fri, 2010-01-15 at 17:14 +0100, Thomas Meyer wrote:
> Am Freitag, den 15.01.2010, 10:54 +0200 schrieb Pekka Enberg:
> 
> > So, any suggestions how I should proceed with figuring out the
> > "flashing" problem I still see with Jesse's patch? I can do a full git
> > bisect if it comes to that but it's going to be bit difficult to
> > determine if a commit is good or bad as there seem to be _two_
> > different problems both of which cause screen flickering.
> > 
> > Heelp!
> 
> Does it look like the video in this bug, see attached video in the bug
> report:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14670

No, that looks more like the "shaking" problem that's fixed by Nick's
and Jesse's patches. The "flashing" bug I'm talking about looks like I'm
seeing an old frame or something that's partially garbled with normal
output. The bug also appears much more infrequently than what your video
shows.

        		Pekka

