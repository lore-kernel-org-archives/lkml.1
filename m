Return-Path: <linux-kernel-owner+w=401wt.eu-S1751492AbYCJLIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492AbYCJLIR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 07:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbYCJLHo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 07:07:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47598 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751250AbYCJLHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 07:07:43 -0400
Date: Mon, 10 Mar 2008 11:10:53 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
Message-ID: <20080310101044.GB9520@elf.ucw.cz>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk> <20080306130643.GB21359@elte.hu> <20080307085341.GA23814@elte.hu> <20080308233604.GA3866@ucw.cz> <87abl812h0.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87abl812h0.fsf@basil.nowhere.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2008-03-09 13:55:23, Andi Kleen wrote:
> Pavel Machek <pavel@ucw.cz> writes:
> > 
> > How many machines are there in your test farm? Would it be possible to
> > make the neccessary scripts available somewhere? I guess I could make
> > one or two machines do some automated testing...
> 
> You can also use autoboot
> 
> ftp://ftp.firstfloor.org/pub/ak/autoboot/autoboot-1.tgz
> 
> [hmm I think it's a slightly older version, but should not 
> be too difficult to adapt]
> 
> These are the scripts we use for automatic testing regularly in Nuernberg.
> 
> It's a little different from Ingo's setup I think though and you
> really need to use remote controllable power switches for it to work
> well [I personally use some cheap USB controlled ones]

I lack the power switches. I wonder how Ingo gets around that?

...OTOH power switch should be only needed when we hit a kernel bug,
that should hopefully be rare...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
