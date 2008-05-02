Return-Path: <linux-kernel-owner+w=401wt.eu-S1764793AbYEBSCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764793AbYEBSCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 14:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758715AbYEBSCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 14:02:45 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:56830 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758307AbYEBSCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 14:02:44 -0400
Date: Fri, 2 May 2008 21:01:51 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Daniel Hazelton <dhazelton@enter.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: How to reduce the number of open kernel bugs
Message-ID: <20080502180151.GD5838@cs181133002.pp.htv.fi>
References: <82e4877d0805020742l7d4a6ec9mc72e79aa3d242348@mail.gmail.com> <200805021229.47038.dhazelton@enter.net> <82e4877d0805021030s793835a1le0032673b0f4c6c7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <82e4877d0805021030s793835a1le0032673b0f4c6c7@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 01:30:23PM -0400, Parag Warudkar wrote:
> On Fri, May 2, 2008 at 12:29 PM, Daniel Hazelton <dhazelton@enter.net> wrote:
> This is what Adrian was pointing
> > ... out and is exactly what shouldn't be happening.
> >
> 
> I wasn't arguing that it is what should be happening - I was just
> pointing out that there are worse things than that routinely happen in
> distro bugzillas!

And the point is?

If I would kill a man it wouldn't become better by pointing out that 
other people were responsible for the killing of several million men.

> Also I feel that if maintainer refuse to fix something - that's a dead
> end as far as that particular bug is considered. We can try and track
> such bugs in different STATUS but there would have to be people
> interested in digging through such bugs and willing to fix it after
> the maintainer has given up. Which is possible but not likely.


You completely miss the point.


>From what I forwarded it's clear that we have a bug somewhere in the 
kernel.

And the maintainer might well be right that it's not in his driver.

Which means to reassign the bug to the maintainer of the area this bug 
is in.


And in any case, being more friendly to a bug submitter.


> Parag

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

