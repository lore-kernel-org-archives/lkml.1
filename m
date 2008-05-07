Return-Path: <linux-kernel-owner+w=401wt.eu-S934380AbYEGXH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934380AbYEGXH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:07:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934351AbYEGXHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:07:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46644 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765561AbYEGXHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:07:14 -0400
Date: Wed, 7 May 2008 16:00:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrea Arcangeli <andrea@qumranet.com>
cc: Andrew Morton <akpm@linux-foundation.org>, clameter@sgi.com,
       steiner@sgi.com, holt@sgi.com, npiggin@suse.de, a.p.zijlstra@chello.nl,
       kvm-devel@lists.sourceforge.net, kanojsarcar@yahoo.com,
       rdreier@cisco.com, swise@opengridcomputing.com,
       linux-kernel@vger.kernel.org, avi@qumranet.com, linux-mm@kvack.org,
       general@lists.openfabrics.org, hugh@veritas.com, rusty@rustcorp.com.au,
       aliguori@us.ibm.com, chrisw@redhat.com, marcelo@kvack.org,
       dada1@cosmosbay.com, paulmck@us.ibm.com
Subject: Re: [PATCH 01 of 11] mmu-notifier-core
In-Reply-To: <20080507222758.GD8276@duo.random>
Message-ID: <alpine.LFD.1.10.0805071558210.3024@woody.linux-foundation.org>
References: <patchbomb.1210170950@duo.random> <e20917dcc8284b6a07cf.1210170951@duo.random> <20080507130528.adfd154c.akpm@linux-foundation.org> <alpine.LFD.1.10.0805071324570.3024@woody.linux-foundation.org> <20080507215840.GB8276@duo.random>
 <alpine.LFD.1.10.0805071509270.3024@woody.linux-foundation.org> <20080507222758.GD8276@duo.random>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 May 2008, Andrea Arcangeli wrote:
>
> I rechecked and I guarantee that the patches where Christoph isn't
> listed are developed by myself and he didn't write a single line on
> them.

How long have you been doing kernel development?

How about you read SubmittingPatches a few times before you show just how 
clueless you are?

Hint: look for the string that says "From:".

Also look at the section that talks about "summary phrase". You got it all 
wrong, and you don't even seem to realize that you got it wrong, even when 
I told you.

		Linus
