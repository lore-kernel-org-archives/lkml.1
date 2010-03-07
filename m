Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894Ab0CGVXr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 16:23:47 -0500
Received: from tundra.namei.org ([65.99.196.166]:59897 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754868Ab0CGVXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 16:23:46 -0500
Date: Mon, 8 Mar 2010 08:23:30 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: linux-kernel@vger.kernel.org
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Upstream first policy
Message-ID: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Mar 2010, Linus Torvalds wrote:

> On Thu, 4 Mar 2010, Kyle McMartin wrote:
>> 
>> I recommend you don't look at Ubuntu, we might have a lot of extra
>> crud[2] in the kernel if you do. :) (Actually, shockingly less than I
>> thought, just apparmor, aufs, ndiswrapper are the obvious ones.)
> 
> Ok, so ndiswrapper falls under the "yeah, no" heading.
> 
> But apparmor was supposed to be on the "yeah, we'll merge it" path, I 
> talked to somebody about it not _that_ long ago. Some of the security 
> people object, but they object for all the wrong reasons and I really do 
> think that since it's getting used, we really should merge it.

The AppArmor developer has been posting patches for review -- there's 
nothing stopping the code being merged except for the need to address 
purely technical issues raised by reviewers, which is ongoing.

See: http://thread.gmane.org/gmane.linux.kernel.lsm/10443

> Although there was _some_ noise about Ubuntu trying to move away from 
> it.. But that may have been more of the whole FUD thing from the people 
> who for some unfathomable reason think that inodes are more important 
> than pathnames.

Hey, thanks for another random unfounded personal attack, it's really 
appreciated.


- James
-- 
James Morris
<jmorris@namei.org>
