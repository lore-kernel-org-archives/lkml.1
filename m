Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbYLLHKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbYLLHKc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 02:10:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYLLHKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 02:10:23 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:45181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751920AbYLLHKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 02:10:21 -0500
Date: Fri, 12 Dec 2008 08:09:59 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markut.t.metzger@intel.com>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@intel.com, markus.t.metzger@gmail.com,
       roland@redhat.com, akpm@linux-foundation.org, eranian@googlemail.com
Subject: Re: [patch 3/3] x86, bts, ftrace: adapt the hw-branch-tracer to
	the ds.c interface
Message-ID: <20081212070959.GC7589@elte.hu>
References: <20081211135326.A13769@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081211135326.A13769@sedona.ch.intel.com>
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


* Markus Metzger <markut.t.metzger@intel.com> wrote:

> Remove BTS bits from the hw-branch-tracer (renamed from bts-tracer) and 
> use the ds interface.
> 
> Signed-off-by: Markus Metzger <markut.t.metzger@intel.com>

applied to tip/tracing/hw-branch-tracing, thanks!

	Ingo
