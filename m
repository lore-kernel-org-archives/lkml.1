Return-Path: <linux-kernel-owner+w=401wt.eu-S1161795AbXECIJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161795AbXECIJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 04:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161793AbXECIJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 04:09:15 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59605 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161791AbXECIJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 04:09:12 -0400
Date: Thu, 3 May 2007 09:09:06 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, wfg@ustc.edu
Subject: Re: 2.6.22 -mm merge plans
Message-ID: <20070503080906.GC23000@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	rusty@rustcorp.com.au, wfg@ustc.edu
References: <20070430162007.ad46e153.akpm@linux-foundation.org> <p733b2gzqkg.fsf@bingen.suse.de> <20070501220803.GA27698@Krystal> <20070502104413.GC4392@one.firstfloor.org> <20070502094707.4197ab7a.akpm@linux-foundation.org> <20070502172934.GA17782@infradead.org> <20070502203627.GA18733@Krystal> <20070502135336.6d6d3569.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070502135336.6d6d3569.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2007 at 01:53:36PM -0700, Andrew Morton wrote:
> In which case we have:
> 
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
> atomich-complete-atomic_long-operations-in-asm-generic.patch
> atomich-i386-type-safety-fix.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
> atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
> atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
> local_t-architecture-independant-extension.patch
> local_t-alpha-extension.patch
> local_t-i386-extension.patch
> local_t-ia64-extension.patch
> local_t-mips-extension.patch
> local_t-parisc-cleanup.patch
> local_t-powerpc-extension.patch
> local_t-sparc64-cleanup.patch
> local_t-x86_64-extension.patch
> 
>   For 2.6.22
> 
> linux-kernel-markers-kconfig-menus.patch
> linux-kernel-markers-architecture-independant-code.patch
> linux-kernel-markers-powerpc-optimization.patch
> linux-kernel-markers-i386-optimization.patch
> markers-add-instrumentation-markers-menus-to-avr32.patch
> linux-kernel-markers-non-optimized-architectures.patch
> markers-alpha-and-avr32-supportadd-alpha-markerh-add-arm26-markerh.patch
> linux-kernel-markers-documentation.patch
> #
> markers-define-the-linker-macro-extra_rwdata.patch
> markers-use-extra_rwdata-in-architectures.patch
> #
> some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
> no-longer-include-asm-kdebugh.patch

This it a plan I can fully agree with.
