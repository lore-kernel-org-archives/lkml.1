Return-Path: <linux-kernel-owner+w=401wt.eu-S1759914AbZFJWBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914AbZFJWBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759570AbZFJWBU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:01:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41683 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759966AbZFJWBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:01:19 -0400
Date: Wed, 10 Jun 2009 15:01:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/cleanups for v2.6.31
In-Reply-To: <20090610211240.GA1425@elte.hu>
Message-ID: <alpine.LFD.2.01.0906101500200.6847@localhost.localdomain>
References: <20090610211240.GA1425@elte.hu>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 10 Jun 2009, Ingo Molnar wrote:

> 
> Please pull the latest x86-cleanups-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-cleanups-for-linus

Just checking - these are all independent and it doesn't much matter which 
order I pull in, right?

That way I can go through the easy ones first, which helps me get around 
to the ones I decide I want to think about more later.

		Linus
