Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbZJKIZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbZJKIZ3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 04:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbZJKIZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 04:25:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42999 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbZJKIZ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 04:25:27 -0400
Date: Sun, 11 Oct 2009 10:24:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [Patch vs. percpu next] Use this_cpu_xx for ftrace
Message-ID: <20091011082427.GB14995@elte.hu>
References: <alpine.DEB.1.10.0910071916040.21638@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0910071916040.21638@gentwo.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Lameter <cl@linux-foundation.org> wrote:

> From: Christoph Lameter <cl@linux-foundation.org>
> Subject: tracing: Use this_cpu_xx for ftrace
> 
> this_cpu_xx can reduce the instruction count here and also
> avoid address arithmetic.
> 
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

Acked-by: Ingo Molnar <mingo@elte.hu>

Thanks Christoph,

	Ingo
