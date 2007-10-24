Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbXJXGvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbXJXGvQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 02:51:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754509AbXJXGvC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 02:51:02 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60538 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656AbXJXGvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 02:51:00 -0400
Date: Wed, 24 Oct 2007 08:50:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] CFS CGroup: Code cleanup
Message-ID: <20071024065019.GB25322@elte.hu>
References: <471EAEBB.8000302@google.com> <20071024044537.GB7099@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024044537.GB7099@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com> wrote:

> On Tue, Oct 23, 2007 at 07:32:27PM -0700, Paul Menage wrote:
> > Clean up some CFS CGroup code
> > 
> > - replace "cont" with "cgrp" in a few places in the CFS cgroup code, 
> > - use write_uint rather than write for cpu.shares write function
> > 
> > Signed-off-by: Paul Menage <menage@google.com>
> 
> Acked-by : Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>

thanks, applied.

	Ingo
