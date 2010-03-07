Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909Ab0CGVcP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Mar 2010 16:32:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59382 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754678Ab0CGVcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Mar 2010 16:32:13 -0500
Date: Sun, 7 Mar 2010 13:31:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: James Morris <jmorris@namei.org>
cc: linux-kernel@vger.kernel.org, Kyle McMartin <kyle@mcmartin.ca>
Subject: Re: Upstream first policy
In-Reply-To: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
Message-ID: <alpine.LFD.2.00.1003071327420.4033@localhost.localdomain>
References: <alpine.LRH.2.00.1003080811220.30507@tundra.namei.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 8 Mar 2010, James Morris wrote:
>
> > it.. But that may have been more of the whole FUD thing from the people 
> > who for some unfathomable reason think that inodes are more important 
> > than pathnames.
> 
> Hey, thanks for another random unfounded personal attack, it's really 
> appreciated.

It really isn't personal, you know. I don't even remember _who_ it was 
that thought that pathname-based security was fundamentally wrong and was 
bad-mouthing apparmor all they could. My point was just that there's a lot 
of mindless "my way or the highway" in some security circles, and apparmor 
really has been ridiculed.

It's not _that_ long ago that some group was trying to get rid of LSM just 
because "selinux is the only valid model".

		Linus
