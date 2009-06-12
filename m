Return-Path: <linux-kernel-owner+w=401wt.eu-S1764313AbZFLLuH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764313AbZFLLuH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 07:50:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbZFLLty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 07:49:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54325 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753528AbZFLLty (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 07:49:54 -0400
Date: Fri, 12 Jun 2009 13:49:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yong Wang <yong.y.wang@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH -tip] perf_counter/x86: Add a quirk for Atom processors
Message-ID: <20090612114948.GD16044@elte.hu>
References: <20090612080855.GA2286@ywang-moblin2.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612080855.GA2286@ywang-moblin2.bj.intel.com>
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


* Yong Wang <yong.y.wang@linux.intel.com> wrote:

> The fixed-function performance counters do not work on current 
> Atom processors. Use the general-purpose ones instead.

ah, nice - applied to tip:perfcounters/core, thanks!

Does this make your Atom testbox work fine now?

	Ingo
