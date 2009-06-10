Return-Path: <linux-kernel-owner+w=401wt.eu-S1759790AbZFJWzE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759790AbZFJWzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:55:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756814AbZFJWyz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:54:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756620AbZFJWyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:54:54 -0400
Date: Wed, 10 Jun 2009 15:54:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cpufeature for v2.6.31
In-Reply-To: <20090610211629.GA11105@elte.hu>
Message-ID: <alpine.LFD.2.01.0906101554320.6847@localhost.localdomain>
References: <20090610211629.GA11105@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Jun 2009, Ingo Molnar wrote:
> 
> Please pull the latest x86-cpufeature-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cpufeature-for-linus

Hmm. This was already part of the irq-tree.

(But at least so far, this merge window looks much cleaner wrt x86 merges. 
I'm hoping there are no nasty surprises down the line ;)

		Linus
