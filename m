Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbYGPVOg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbYGPVOg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:14:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYGPVO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:14:28 -0400
Received: from csclub.uwaterloo.ca ([129.97.134.17]:47425 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752686AbYGPVO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:14:27 -0400
Date: Wed, 16 Jul 2008 17:14:27 -0400
To: Byron Stanoszek <bstanoszek@comtime.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080716211427.GH31126@csclub.uwaterloo.ca>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <Pine.LNX.4.64.0807150938280.12665@winds.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0807150938280.12665@winds.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 10:07:21AM -0400, Byron Stanoszek wrote:
> Well, we just haven't had anything big enough to merit an increase in the
> minor number lately. I nominate the removal of the BKL as one such feature,
> based on the sheer work required and how many modules you'll need to touch 
> to
> do so. In fact, it would be the natural conclusion to a 2.x series that
> highlighted SMP as its primary new feature.
> 
> But it's hard now to predict future milestones, or when an overall paradigm
> shift might happen. In those cases you'll want to give Linux a bright new
> announcement to the world, instead of it being "just another standard year 
> of
> kernel development".
> 
> Remember, you used to have versions called 1.3.100 before -- and they seemed
> perfectly normal back then. I personally like how we're still on 2.y.z 
> numbers
> compared to all of the other OSes (Solaris 11, HP-UX 11)...it makes Linux 
> still
> feel young, showing how much better it can get ;-)
> 
> So I vote for releasing by "features" still, and keep the current numbering
> scheme. Who knows when the next big idea will pop up that's worthy of 3.0.0.

Didn't HP-UX 11 come out around a decade ago?  Did they stop
development?

-- 
Len Sorensen
