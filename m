Return-Path: <linux-kernel-owner+w=401wt.eu-S1758359AbZFKNAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758359AbZFKNAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751243AbZFKNAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:00:47 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54926 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZFKNAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:00:46 -0400
Date: Thu, 11 Jun 2009 15:00:41 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Bob Copeland <me@bobcopeland.com>
Cc: Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       ibm@android.com, san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611130039.GG7523@elf.ucw.cz>
References: <20090610103131.GB13885@elf.ucw.cz> <a55d774e0906101043q580fc5e5iad25a79203dc52c@mail.gmail.com> <20090611081012.GD8592@elf.ucw.cz> <a55d774e0906110127k1633dd90x96863c3dd6f888cf@mail.gmail.com> <20090611110946.GA7523@elf.ucw.cz> <b6c5339f0906110545l5ced1039tf7baac3fab2450e2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6c5339f0906110545l5ced1039tf7baac3fab2450e2@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 08:45:36, Bob Copeland wrote:
> On Thu, Jun 11, 2009 at 7:09 AM, Pavel Machek<pavel@ucw.cz> wrote:
> > Anyway, now I have a tree, and yes it compiles. (After some
> > "interesting" questions; perhaps defconfig should be updated?)
> 
> > ...and I just selected "3" being default. No help available :-(. I
> > have cupcake installed, and I believe I installed radio update
> > required for cupcake. Can someone help?
> 
> I can send you my .config if you want, I have it working.

That would be cool...

> Note you need the latest userland because the initrd details changed
> a bit (e.g. a 2.6.29 kernel will not work on the 1.1 userland, but
> will work on 1.5, something to do with mounting the filesystems, I
> can't remember exactly from my serial traces.)

I do have cupcake userland (from JF)... When I change command line
options or try to boot zImage, it hangs with rainbow screen.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
