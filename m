Return-Path: <linux-kernel-owner+w=401wt.eu-S1758932AbZCUOfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932AbZCUOfs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 10:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752700AbZCUOfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 10:35:39 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35852 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZCUOfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 10:35:39 -0400
Date: Sat, 21 Mar 2009 15:34:57 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Renzo Davoli <renzo@cs.unibo.it>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>, utrace-devel@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] utrace core
Message-ID: <20090321143457.GA24254@elte.hu>
References: <20090321013946.890F4FC3AB@magilla.sf.frob.com> <20090321014140.AA4F5FC3AB@magilla.sf.frob.com> <20090321014909.6b654f55.akpm@linux-foundation.org> <20090321140822.GE18690@cs.unibo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090321140822.GE18690@cs.unibo.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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


* Renzo Davoli <renzo@cs.unibo.it> wrote:

> Tracing does not mean only debug. Some tracing facilities can be 
> used for virtualization. For example User-Mode Linux is based on 
> ptrace.
> 
> I have a prototype of kernel module for virtualization (kmview) 
> based on utrace. [...]

Hm, i cannot find the source code. Can it be downloaded from 
somewhere?

	Ingo
