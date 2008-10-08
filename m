Return-Path: <linux-kernel-owner+w=401wt.eu-S1755234AbYJHGny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbYJHGny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 02:43:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751561AbYJHGnq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 02:43:46 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58012 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbYJHGnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 02:43:46 -0400
Subject: Re: [BUG] SLOB's krealloc() seems bust
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Matt Mackall <mpm@selenic.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-mm <linux-mm@kvack.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       akpm <akpm@linuxfoundation.org>
In-Reply-To: <1223442947.13453.462.camel@calx>
References: <1223387841.26330.36.camel@lappy.programming.kicks-ass.net>
	 <1223441190.13453.459.camel@calx>
	 <200810081554.33651.nickpiggin@yahoo.com.au>
	 <200810081611.30897.nickpiggin@yahoo.com.au>
	 <1223442947.13453.462.camel@calx>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 08:43:40 +0200
Message-Id: <1223448220.1378.13.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-08 at 00:15 -0500, Matt Mackall wrote:

> Damnit, how many ways can we get confused by these little details? I'll
> spin a final version and run it against the test harness shortly.

So I'll wait with testing for the next version?

