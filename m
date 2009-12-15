Return-Path: <linux-kernel-owner+w=401wt.eu-S933208AbZLOULp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933208AbZLOULp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 15:11:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932998AbZLOULo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 15:11:44 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55104 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932797AbZLOULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 15:11:43 -0500
Date: Tue, 15 Dec 2009 21:11:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Dmitri Vorobiev <dmitri.vorobiev@movial.com>
Cc: linux-kernel@vger.kernel.org, Mures Andone <mures.andone@movial.com>
Subject: Re: Add missing header for HTC Dream framebuffer
Message-ID: <20091215201136.GJ24406@elf.ucw.cz>
References: <e50e54220912110721x3d3ffb4ard8f458923db005bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e50e54220912110721x3d3ffb4ard8f458923db005bc@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-12-11 17:21:00, Dmitri Vorobiev wrote:
> Hi Pavel,
> 
> I'm wondering what happened to the patch [1] that added
> include/linux/msm_mdp.h? I would be very interested in having this
> header at where it belongs, and think that since the merge window is
> open now, it would be good time to get back to that patch. :)

I hope it is in akpm tree somewhere. If it is not there in -rc1 we can
retransmit it.

> [1] http://lkml.org/lkml/2009/10/28/348

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
