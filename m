Return-Path: <linux-kernel-owner+w=401wt.eu-S1766875AbXDSQyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766875AbXDSQyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 12:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766876AbXDSQyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 12:54:18 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48736 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1766875AbXDSQyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 12:54:17 -0400
Date: Thu, 19 Apr 2007 09:53:00 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Avi Kivity <avi@qumranet.com>
cc: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: Re: [GIT PULL] kvm oops fix
In-Reply-To: <1176997839110-git-send-email-avi@qumranet.com>
Message-ID: <alpine.LFD.0.98.0704190949580.9964@woody.linux-foundation.org>
References: <1176997839110-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Apr 2007, Avi Kivity wrote:
> 
> Please pull from the 'linus' branch of
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git

*please* put the branch-name after the git repo, so that I can 
cut-and-paste without noticing only afterwards that the diffstat doesn't 
match what it was supposed to, and I got the wrong commits, and have to 
undo and re-do the pull..

Yeah, I didn't do that mistake this time, and in fact, I seldom do, but 
every time the branch is mentioned somewhere else than with the actual 
repo to pull, I get nervous. 

So I've said this a million times before, but I'll say it one more 
time: if it's not the main branch, the message should be

   Please pull from the 'linus' branch of

     git://git.kernel.org/pub/scm/linux/kernel/git/avi/kvm.git linus

   to get the following changes: ...

so that when I cut-and-paste the URL (you didn't think I'd try to type it 
in by hand, did you?) I get the branch automatically.

		Linus
