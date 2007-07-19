Return-Path: <linux-kernel-owner+w=401wt.eu-S1762206AbXGSUZz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762206AbXGSUZz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:25:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbXGSUZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:25:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50583 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757312AbXGSUZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:25:45 -0400
Date: Thu, 19 Jul 2007 13:25:07 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Christoph Lameter <clameter@sgi.com>
Subject: Re: [patch] slub crashes with recent -git
In-Reply-To: <alpine.LFD.0.999.0707191307220.27249@woody.linux-foundation.org>
Message-ID: <alpine.LFD.0.999.0707191324020.27249@woody.linux-foundation.org>
References: <20070719194234.GA27917@elte.hu>
 <alpine.LFD.0.999.0707191307220.27249@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 19 Jul 2007, Linus Torvalds wrote:
> 
> A better patch should be the appended. Does that work for you too?

Btw, I already committed this as obvious. 

I did the same for the SLAB __do_kmalloc() thing. Let's hope that that was 
the extent of the damage.

		Linus
