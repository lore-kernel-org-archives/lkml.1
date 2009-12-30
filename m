Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbZL3UvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbZL3UvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:51:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbZL3UvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:51:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52092 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753500AbZL3UvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:51:15 -0500
Date: Wed, 30 Dec 2009 12:51:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Theodore Ts'o" <tytso@mit.edu>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] ext4 updates for v2.6.33
In-Reply-To: <E1NOdOL-0001s1-4J@closure.thunk.org>
Message-ID: <alpine.LFD.2.00.0912301249520.11961@localhost.localdomain>
References: <E1NOdOL-0001s1-4J@closure.thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 26 Dec 2009, Theodore Ts'o wrote:
> 
> Please pull from:
> 
>         git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus
> 
> to grab the following bug fixes for v2.6.33.

I don't get the diffstat you claim, so I'm unpulling. I've got a lot of 
extra work in fs/ext4/inode.c, and fewer lines in fs/ext4/extents.c, for a 
total of

  15 files changed, 189 insertions(+), 94 deletions(-)

instead of you claimed

>  15 files changed, 108 insertions(+), 24 deletions(-)

Hmm?

		Linus
