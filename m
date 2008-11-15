Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954AbYKOTlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954AbYKOTlh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2008 14:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751963AbYKOTl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Nov 2008 14:41:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50583 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751959AbYKOTl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2008 14:41:27 -0500
Date: Sat, 15 Nov 2008 11:40:54 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Van Hensbergen <ericvh@gmail.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] bug fixes for 9p linux-2.6.28-rc4
In-Reply-To: <a4e6962a0811141425n119d624bk8a1a0e3b9c3a9eab@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0811151139190.3468@nehalem.linux-foundation.org>
References: <a4e6962a0811141425n119d624bk8a1a0e3b9c3a9eab@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 Nov 2008, Eric Van Hensbergen wrote:
>
> The following changes since commit 4ff429e658c00bcf5101eabbebd4f711572a64cb:
>   Randy Dunlap (1):
>         9p: restrict RDMA usage
> 
> are available in the git repository at:
> 
>   ssh://master.kernel.org/pub/scm/linux/kernel/git/ericvh/v9fs.git for-linus

Diffstat?

Yeah, I see that it is

 net/9p/Kconfig |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

but I want to know things like that _before_ pulling, just to know what to 
expect, and so that I know that what I pull is what you meant me to pull.

		Linus
