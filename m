Return-Path: <linux-kernel-owner+w=401wt.eu-S1756429AbYFERdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429AbYFERdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbYFERd2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:33:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752907AbYFERdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:33:25 -0400
Date: Thu, 5 Jun 2008 10:33:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: npiggin@suse.de
cc: akpm@linux-foundation.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, benh@kernel.crashing.org,
       paulus@samba.org
Subject: Re: [patch 0/7] speculative page references, lockless pagecache,
 lockless gup
In-Reply-To: <20080605094300.295184000@nick.local0.net>
Message-ID: <alpine.LFD.1.10.0806051031580.3473@woody.linux-foundation.org>
References: <20080605094300.295184000@nick.local0.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jun 2008, npiggin@suse.de wrote:
> 
> I've decided to submit the speculative page references patch to get merged.
> I think I've now got enough reasons to get it merged. Well... I always
> thought I did, I just didn't think anyone else thought I did. If you know
> what I mean.

So I'd certainly like to see these early in the 2.6.27 series. 

Nick, will you just re-send them once 2.6.26 is out? Or do they cause 
problems for Andrew and he wants to be part of the chain? I'm fine with 
either.

		Linus
