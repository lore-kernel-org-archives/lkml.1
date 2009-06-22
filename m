Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbZFVL7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbZFVL7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754544AbZFVL65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:58:57 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZFVL64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:58:56 -0400
Date: Mon, 22 Jun 2009 13:58:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: eranian@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: IV.1 - Support for model-specific uncore PMU
Message-ID: <20090622115841.GP24366@elte.hu>
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> IV/ Open questions
>
> 1/ Support for model-specific uncore PMU monitoring capabilities
>
> Recent processors have multiple PMUs. Typically one per core and
> but also one at the socket level, e.g., Intel Nehalem. It is
> expected that this API will provide access to these PMU as well.
>
> It seems like with the current API, raw events for those PMU would
> need a new architecture-specific type as the event encoding by
> itself may not be enough to disambiguate between a core and uncore
> PMU event.
>
> How are those events going to be supported?

(Please see our reply to II.2.)
