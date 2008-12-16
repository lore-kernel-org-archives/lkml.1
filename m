Return-Path: <linux-kernel-owner+w=401wt.eu-S1755602AbYLPR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755602AbYLPR3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 12:29:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751406AbYLPR3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 12:29:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38723 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751078AbYLPR3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 12:29:11 -0500
Date: Tue, 16 Dec 2008 18:29:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com
Subject: Re: [patch 3/3] x86, bts: correctly report invalid bts records
Message-ID: <20081216172900.GC11683@elte.hu>
References: <20081216155311.A30159@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081216155311.A30159@sedona.ch.intel.com>
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

> Correctly report a cleared BTS record as invalid. Used to be reported
> as branch from 0 to 0.
> 
> 
> Signed-off-by: Markus Metzger <markus.t.metzger@intel.com>

applied to tip/tracing/hw-branch-tracer, thanks,

	Ingo
