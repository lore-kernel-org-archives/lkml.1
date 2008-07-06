Return-Path: <linux-kernel-owner+w=401wt.eu-S1756320AbYGFATk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320AbYGFATk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 20:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753088AbYGFATc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 20:19:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42260 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753057AbYGFATc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 20:19:32 -0400
Date: Sat, 5 Jul 2008 17:19:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Grant Coady <gcoady.lk@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.26-rc9
In-Reply-To: <f31074112h7jusi98q1a7ln3g2nhi6k5ko@4ax.com>
Message-ID: <alpine.LFD.1.10.0807051718470.3016@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0807051557500.3016@woody.linux-foundation.org> <f31074112h7jusi98q1a7ln3g2nhi6k5ko@4ax.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 6 Jul 2008, Grant Coady wrote:
> 
> Noticed the stale LATEST-IS-* entries no longer being removed at:

Heh. They were never removed automatically, it requires somebody to 
remember to remove the old ones. Which I obviously haven't been doing 
lately.

Should be fixed now.

		Linus
