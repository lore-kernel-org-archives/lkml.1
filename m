Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0CKJOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:14:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34148 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0CKJOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:14:49 -0500
Date: Thu, 11 Mar 2010 04:14:44 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: export perf_trace_regs and
	perf_arch_fetch_caller_regs
Message-ID: <20100311091444.GA19699@infradead.org>
References: <4B989C1B.2090407@cn.fujitsu.com> <20100311090248.GA10904@infradead.org> <1268298651.5279.986.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268298651.5279.986.camel@twins>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 11, 2010 at 10:10:51AM +0100, Peter Zijlstra wrote:
> Pretty much all modular tracepoint users I think, I just got this from a
> pp64_defconfig build:

Interesting, that doesn't happen in mainline yet.

