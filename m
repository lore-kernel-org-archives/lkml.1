Return-Path: <linux-kernel-owner+w=401wt.eu-S1759104AbZFJUeL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759104AbZFJUeL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 16:34:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755779AbZFJUd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 16:33:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48123 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755598AbZFJUd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 16:33:58 -0400
Date: Wed, 10 Jun 2009 13:32:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, hannes@cmpxchg.org, mingo@elte.hu,
       mpm@selenic.com, npiggin@suse.de, yinghai@kernel.org
Subject: Re: [GIT PULL] Early boot SLAB for 2.6.31
In-Reply-To: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
Message-ID: <alpine.LFD.2.01.0906101331250.6847@localhost.localdomain>
References: <Pine.LNX.4.64.0906102311230.30444@melkki.cs.Helsinki.FI>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Jun 2009, Pekka J Enberg wrote:
> 
> I already have patches for that but they are against the -tip tree so I think
> we ought to just merge this series to mainline and fix everything up in
> subsystem trees for 2.6.31 proper.

Hmm. Are there any reasons why the scheduler fixups can't go in this 
series? Do they depend on other things in -tip?

		Linus
