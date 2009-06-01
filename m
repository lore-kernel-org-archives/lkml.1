Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZFAHzs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZFAHzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 03:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752488AbZFAHzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 03:55:41 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:55147 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbZFAHzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 03:55:40 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18979.35192.995732.609215@cargo.ozlabs.ibm.com>
Date: Mon, 1 Jun 2009 17:55:36 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf_counter: Provide functions for locking and pinning the context for a task
In-Reply-To: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
References: <18979.34748.755674.596386@cargo.ozlabs.ibm.com>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, forgot to put sequence numbers on these patches.  They are:

[PATCH 1/4] perf_counter: Provide functions for locking and pinning the
context for a task
[PATCH 2/4] perf_counter: Allow software counters to count while task is
not running
[PATCH 3/4] perf_counter: Fix cpu migration counter
[PATCH 4/4] perf_counter: Remove unused prev_state field

Paul.
