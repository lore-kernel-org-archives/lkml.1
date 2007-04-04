Return-Path: <linux-kernel-owner+w=401wt.eu-S2993044AbXDDTPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993044AbXDDTPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993039AbXDDTPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:15:50 -0400
Received: from smtp.osdl.org ([65.172.181.24]:53323 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993044AbXDDTPs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:15:48 -0400
Date: Wed, 4 Apr 2007 12:15:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Hugh Dickins <hugh@veritas.com>,
       Linux Memory Management List <linux-mm@kvack.org>, tee@sgi.com,
       holt@sgi.com, Andrea Arcangeli <andrea@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] no ZERO_PAGE?
Message-Id: <20070404121533.cd222192.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org>
References: <20070329075805.GA6852@wotan.suse.de>
	<Pine.LNX.4.64.0703291324090.21577@blonde.wat.veritas.com>
	<20070330024048.GG19407@wotan.suse.de>
	<20070404033726.GE18507@wotan.suse.de>
	<Pine.LNX.4.64.0704040830500.6730@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Apr 2007 08:35:30 -0700 (PDT) Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Does anybody do any performance testing on -mm?

http://test.kernel.org/perf/index.html has pretty graphs of lots of kernel versions
for a few benchmarks.  I'm not aware of any other organised effort along those
lines.
