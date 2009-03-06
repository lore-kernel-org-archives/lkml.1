Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZCFOlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZCFOlp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:41:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488AbZCFOle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:41:34 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:39492 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbZCFOlc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:41:32 -0500
Date: Fri, 6 Mar 2009 15:41:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Markus Metzger <markus.t.metzger@intel.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@zytor.com,
       markus.t.metzger@gmail.com, roland@redhat.com, eranian@googlemail.com,
       oleg@redhat.com, juan.villacis@intel.com, ak@linux.jf.intel.com,
       srostedt@redhat.com
Subject: Re: [patch 4/4] x86, hw-branch-tracer: add selftest
Message-ID: <20090306144116.GD21907@elte.hu>
References: <20090305163149.A9720@sedona.ch.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305163149.A9720@sedona.ch.intel.com>
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

> +	/* the hw-branch tracer needs to collect the trace from the various
> +	 * cpu trace buffers - before tracing is stopped. */

The comment style is wrong here too.

	Ingo
