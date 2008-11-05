Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464AbYKERbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464AbYKERbe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 12:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbYKERbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 12:31:25 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39635 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbYKERbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 12:31:25 -0500
Date: Wed, 5 Nov 2008 18:33:03 +0100
From: Pavel Machek <pavel@suse.cz>
To: Dmitry <dbaryshkov@gmail.com>
Cc: rpurdie@rpsys.net, lenz@cs.wisc.edu,
       kernel list <linux-kernel@vger.kernel.org>,
       Russell King <rmk@arm.linux.org.uk>, Dirk@opfer-online.de,
       arminlitzel@web.de, pavel.urban@ct.cz, Cyril Hrubis <metan@ucw.cz>,
       thommycheck@gmail.com
Subject: Re: 2.6.28-rc3-git1: spitz still won't boot
Message-ID: <20081105173303.GC2038@elf.ucw.cz>
References: <20081031150601.GA1457@ucw.cz> <20081105142329.GA1724@ucw.cz> <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc64b4640811050713i4cfb1216x822274150e929e02@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2008-11-05 18:13:19, Dmitry wrote:
> 2008/11/5 Pavel Machek <pavel@suse.cz>:
> > On Fri 2008-10-31 16:06:01, Pavel Machek wrote:
> >> Hi!
> >>
> >> ...unfortunately, 2.6.27 contains the 'reset floating' bug, and from
> >> the point 'reset floating' is fixed, to 2.6.28-rc1, tree will not
> >> compile, so bisect is quite hard to do. Any ideas?
> >
> > It is still there in -rc3... And yes, it is a regression from 2.6.27.
> 
> Would you be so nice to provide a boot log of 2.6.28-rc3 with
> CONFIG_DEBUG_DRIVER enabled?

I'd love to, but it fails with black screen :-(. (But I guess I should
mention that I'm using kexec...)

Do you have "good" config for spitz I could try? (Similar
configuration worked in 2.6.27, but maybe it is a config difference?)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
