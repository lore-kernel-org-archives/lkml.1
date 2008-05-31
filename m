Return-Path: <linux-kernel-owner+w=401wt.eu-S1754229AbYEaDp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbYEaDp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 23:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYEaDpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 23:45:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750914AbYEaDpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 23:45:15 -0400
Date: Fri, 30 May 2008 20:44:55 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ulrich Drepper <drepper@redhat.com>
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com
Subject: Re: [PATCH 0/3] 64-bit futexes: Intro
In-Reply-To: <4840C29B.6030507@redhat.com>
Message-ID: <alpine.LFD.1.10.0805302044310.3141@woody.linux-foundation.org>
References: <200805310127.m4V1RLR4013808@devserv.devel.redhat.com> <alpine.LFD.1.10.0805301846530.3141@woody.linux-foundation.org> <4840C29B.6030507@redhat.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 30 May 2008, Ulrich Drepper wrote:

> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Linus Torvalds wrote:
> > We've had a 32-bit rwsemaphore in the kernel for a *long* time.
> 
> You misread what I wrote.

No, you do.

The kernel calls reader-writer locks rwsemaphores.

		Linus
