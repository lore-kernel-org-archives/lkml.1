Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbYLTISh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbYLTISh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2008 03:18:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754010AbYLTISZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Dec 2008 03:18:25 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58033 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017AbYLTISZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2008 03:18:25 -0500
Date: Sat, 20 Dec 2008 09:18:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com
Subject: Re: [patch 2/2] x86, bts: memory accounting
Message-ID: <20081220081813.GB5581@elte.hu>
References: <20081219151702.A5121@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219151702.A5121@sedona.ch.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Markus Metzger <markus.t.metzger@intel.com> wrote:

> Add alloc_locked_buffer() and free_locked_buffer() functions to mm/mlock.c to kalloc a buffer and account the locked memory to current.
> 
> Account the memory for the BTS buffer to the tracer.
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

applied to tip/tracing/hw-branch-tracer, thanks!

	Ingo
