Return-Path: <linux-kernel-owner+w=401wt.eu-S932596AbZJJPhE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932596AbZJJPhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 11:37:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761646AbZJJPhE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 11:37:04 -0400
Received: from www.tglx.de ([62.245.132.106]:55232 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZJJPhD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 11:37:03 -0400
Message-Id: <20091010153314.827301943@linutronix.de>
User-Agent: quilt/0.47-1
Date: Sat, 10 Oct 2009 15:35:16 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vincent Sanders <vince@simtec.co.uk>, John Kacur <jkacur@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 00/28] BKL removal queued patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm sending out the pending BKL removal patches which I collected so
far to avoid duplicate work and to solicit review/comments.

If nobody objects I'd like to keep them in one git branch which is
going to be included into linux-next.

Thanks,

	tglx



