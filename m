Return-Path: <linux-kernel-owner+w=401wt.eu-S1763820AbYBWUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763820AbYBWUKw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:10:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752723AbYBWUKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:10:42 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38451 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752722AbYBWUKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:10:41 -0500
Date: Sat, 23 Feb 2008 12:09:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Hugh Dickins <hugh@veritas.com>, Mike Travis <travis@sgi.com>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix DEBUG_PREEMPT per_cpu checking
In-Reply-To: <20080223120610.a31dbdf4.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802231209410.21332@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0802231927500.13934@blonde.site> <20080223120610.a31dbdf4.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Feb 2008, Andrew Morton wrote:
> 
> Hopefully Linus will apply the patch from Hugh's email, but that isn't the
> general solution to this increasingly worse problem.

Done.

		Linus
