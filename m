Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZBVOsf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZBVOsf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 09:48:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755888AbZBVOsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 09:48:21 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:42136 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755609AbZBVOsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 09:48:20 -0500
Date: Sun, 22 Feb 2009 15:48:11 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: jmorris@namei.org, takedakn@nttdata.co.jp,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, haradats@nttdata.co.jp
Subject: Re: [TOMOYO #15 0/8] TOMOYO Linux
Message-ID: <20090222144811.GJ1586@ucw.cz>
References: <20090205081810.331987920@nttdata.co.jp> <alpine.LRH.1.10.0902121632160.18265@tundra.namei.org> <20090222142327.GF1586@ucw.cz> <200902222327.CIF26085.LOOJVMHQFOFStF@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902222327.CIF26085.LOOJVMHQFOFStF@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-02-22 23:27:34, Tetsuo Handa wrote:
> Pavel Machek wrote:
> > On Thu 2009-02-12 16:34:16, James Morris wrote:
> > > On Thu, 5 Feb 2009, Kentaro Takeda wrote:
> > > 
> > > > TOMOYO Linux is a name-based MAC extension (LSM module) for the Linux kernel.
> > > > 
> > > 
> > > Applied to 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next
> > > 
> > 
> > Does that mean tomoyo is scheduled for 2.6.30?
> > 
> TOMOYO is already in linux-next tree and ready to go into 2.6.30 .

Last time I looked it included script parser and some
interpretter... Was that solved?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
