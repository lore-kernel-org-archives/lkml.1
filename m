Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbYEGOnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbYEGOnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 10:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760623AbYEGOi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 10:38:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39342 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758630AbYEGOi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 10:38:26 -0400
Date: Wed, 7 May 2008 07:37:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Re: [RFC no patch yet] bootmem2: Another try
In-Reply-To: <87ve1qcn6n.fsf@saeurebad.de>
Message-ID: <alpine.LFD.1.10.0805070737100.32269@woody.linux-foundation.org>
References: <20080505095938.326928514@symbol.fehenstaub.lan> <87ve1qcn6n.fsf@saeurebad.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 7 May 2008, Johannes Weiner wrote:
> 
> Bootmem2 is block-oriented where a block represents a contiguous range
> of physical memory.  Every block has a bitmap that keeps track of the
> pages on it.

Yes, that one sounds fairly sane.

		Linus
