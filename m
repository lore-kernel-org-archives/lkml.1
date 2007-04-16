Return-Path: <linux-kernel-owner+w=401wt.eu-S1753553AbXDPUiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553AbXDPUiT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 16:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753586AbXDPUiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 16:38:19 -0400
Received: from mx2.suse.de ([195.135.220.15]:53013 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbXDPUiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 16:38:13 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       William Lee Irwin III <wli@holomorphy.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matt Mackall <mpm@selenic.com>, linux-kernel@vger.kernel.org,
       fche@redhat.com
Subject: Re: [PATCH 0/13] maps: pagemap, kpagemap, and related cleanups
References: <20070412182213.a18cc4a7.akpm@linux-foundation.org>
	<461EE005.6070605@yahoo.com.au>
	<20070412185723.5a5f0443.akpm@linux-foundation.org>
	<461EE890.2040601@yahoo.com.au>
	<20070412193255.62a0b8ed.akpm@linux-foundation.org>
	<461EEFEC.2010205@yahoo.com.au> <20070413065357.GP2986@holomorphy.com>
	<461F2BCB.2020200@yahoo.com.au> <20070413075142.GA23822@infradead.org>
	<461F3961.6030300@yahoo.com.au> <20070413081338.GA27675@infradead.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 16 Apr 2007 23:36:05 +0200
In-Reply-To: <20070413081338.GA27675@infradead.org>
Message-ID: <p73zm5857ei.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> writes:

> and does a lot of really wrong things in it's runtime).

I must agree with that. Perhaps it would be good if its runtime code
was posted to l-k at some point and reviewed in the standard way
even when it isn't merged.

-Andi
