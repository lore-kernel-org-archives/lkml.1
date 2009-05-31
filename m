Return-Path: <linux-kernel-owner+w=401wt.eu-S1755838AbZEaM2q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbZEaM2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 08:28:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZEaM2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 08:28:40 -0400
Received: from oblivion.subreption.com ([66.240.236.22]:36973 "EHLO
	mail.subreption.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053AbZEaM2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 08:28:39 -0400
Date: Sun, 31 May 2009 05:30:15 -0700
From: "Larry H." <research@subreption.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, pageexec@freemail.hu,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
	allocator
Message-ID: <20090531123015.GD10598@oblivion.subreption.com>
References: <20090530180333.GH6535@oblivion.subreption.com> <20090530182113.GA25237@elte.hu> <20090530184534.GJ6535@oblivion.subreption.com> <20090530190828.GA31199@elte.hu> <4A21999E.5050606@redhat.com> <84144f020905301353y2f8c232na4c5f9dfb740eec4@mail.gmail.com> <20090530213311.GM6535@oblivion.subreption.com> <84144f020905310017o3c2b8c52s7d62187cf794e854@mail.gmail.com> <20090531115828.GB10598@oblivion.subreption.com> <84144f020905310516x692bd870vfbbfc1e734e57326@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020905310516x692bd870vfbbfc1e734e57326@mail.gmail.com>
Organization: Subreption LLC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15:16 Sun 31 May     , Pekka Enberg wrote:
> On Sun, May 31, 2009 at 2:58 PM, Larry H. <research@subreption.com> wrote:
> > Thanks for coming to the conclusion that unconditional memory
> > sanitization is the correct approach.
> >
> > I thought this had been stated numerous times before in this thread. Are
> > you serious about your responses or you are just clowning around? It's
> > amusing, I give you that much.
> 
> So is this the same Larry that was able to have a productive and civil
> discussion on #mm on IRC where he wanted me to ACK his patches? Or did
> his evil identical twin take over the keyboard?

I was merely making sure what your intentions were regarding the
patches. And it's clear you have utter disregard for them, and security
as a whole. In your idea of the world 'there are no secrets'.

Good luck with that.

> But anyway, enough is enough, and I really am not interested in this
> discussion. I wish you the best of luck getting your patches merged. I
> suspect you're gonna need it.

I submitted them so other people could benefit from it. In the end I
could care less about what you do with them, or if they are merged.
Now that is clear that trying to do so is a waste of time and energy,
I'm free to go with a clean conscience, knowing that these patches
didn't help others because I didn't try to, but because some council of
vagueness decided it doesn't fit their particularly flawed view of the
world.

See you in the next commit fixing a kernel vulnerability silently that
puts the infrastructure of several organizations at risk for your own
disregard.

	Larry.

