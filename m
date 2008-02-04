Return-Path: <linux-kernel-owner+w=401wt.eu-S1758295AbYBDXi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758295AbYBDXi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 18:38:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754570AbYBDXiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 18:38:46 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:52382 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757835AbYBDXin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 18:38:43 -0500
Date: Tue, 5 Feb 2008 00:39:01 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Abel Bernabeu <abel.bernabeu@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Fwd: brk randomization breaks columns
Message-ID: <20080204233901.GB1559@elf.ucw.cz>
References: <20080204122837.GA1647@elf.ucw.cz> <20080204130156.GA8730@elte.hu> <Pine.LNX.4.64.0802041528470.30955@jikos.suse.cz> <Pine.LNX.4.64.0802041635000.30955@jikos.suse.cz> <15577be70802041016m97cddbfk43b9073408bcbce9@mail.gmail.com> <15577be70802041029o2975ba6do34589bbdc81d1652@mail.gmail.com> <20080204195251.GB4915@elf.ucw.cz> <15577be70802041354s23e5b289w56f724dfdf8c3242@mail.gmail.com> <Pine.LNX.4.64.0802042346020.30873@twin.jikos.cz> <15577be70802041513p796172b2y2e17b7882763b02c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15577be70802041513p796172b2y2e17b7882763b02c@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Abel, I actually don't think you have chance to have any issues with
> > randomization, as the mentioned post talks about 2.6.22.10, which doesn't
> > randomize the brk start at all.
> 
> You are rigth, my kernel just randomizes stack top.
> 
> I've got a bit sick with this crash in the latest days, trying to
> understand the elf loader, trying toolchain configurations, etc... O:)

Well, elf loader is indeed evil.
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
