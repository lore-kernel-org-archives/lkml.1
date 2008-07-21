Return-Path: <linux-kernel-owner+w=401wt.eu-S1753119AbYGURnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753119AbYGURnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 13:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbYGURnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 13:43:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751649AbYGURnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 13:43:03 -0400
Date: Mon, 21 Jul 2008 10:42:32 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] x86 updates for v2.6.27, phase #2
In-Reply-To: <20080721153256.GA13557@elte.hu>
Message-ID: <alpine.LFD.1.10.0807211041530.31863@woody.linux-foundation.org>
References: <20080721150415.GA19921@elte.hu> <20080721153256.GA13557@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 21 Jul 2008, Ingo Molnar wrote:
> 
> i'll fix it ... Dprintk in apic.h is historic and ugly. Should i redo 
> the tree and the pull request?

I already pulled it, so please just send a (tested) patch. But it would 
have ben _so_ much better to have noticed this before-the-fact.

		Linus
