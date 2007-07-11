Return-Path: <linux-kernel-owner+w=401wt.eu-S1761841AbXGKJgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761841AbXGKJgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 05:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbXGKJgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 05:36:32 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46172 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756247AbXGKJgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 05:36:31 -0400
Date: Wed, 11 Jul 2007 10:36:26 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Theodore Tso <tytso@mit.edu>,
       linux-kernel@vger.kernel.org, Andi Kleen <ak@suse.de>,
       Amit Arora <aarora@in.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: testcases, was Re: -mm merge plans for 2.6.23 -- sys_fallocate
Message-ID: <20070711093626.GB19061@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
	Andi Kleen <ak@suse.de>, Amit Arora <aarora@in.ibm.com>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org> <20070710090737.GA16519@osiris.boeblingen.de.ibm.com> <20070710022213.81e7b432.akpm@linux-foundation.org> <20070710154503.GC27033@thunk.org> <20070710180531.GB8908@osiris.ibm.com> <20070710114119.d8e874a1.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710114119.d8e874a1.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 11:41:19AM -0700, Andrew Morton wrote:
> I'd support an ununofficial rule that submitters of new syscalls also raise
> a patch against LTP, come to that...

s/ununofficial//, please.  And extend this to every new kernel interface
that's not bound to a specific piece of hardware.
