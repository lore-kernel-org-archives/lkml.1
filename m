Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZIXOvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZIXOvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZIXOvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:51:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:56943 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752573AbZIXOvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:51:20 -0400
Subject: Re: [patch 12/12] Tracepoints - Immediate Values
From: Peter Zijlstra <peterz@infradead.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>, Hideo AOKI <haoki@redhat.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20090924133400.830759403@polymtl.ca>
References: <20090924132626.485545323@polymtl.ca>
	 <20090924133400.830759403@polymtl.ca>
Content-Type: text/plain
Date: Thu, 24 Sep 2009 16:51:12 +0200
Message-Id: <1253803872.18939.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-24 at 09:26 -0400, Mathieu Desnoyers wrote:
> plain text document attachment (tracepoints-immediate-values.patch)
> Use immediate values in tracepoints.

I might have missed it, but did both the Intel and AMD cpu folks clear
the SMP code rewrite bits?

