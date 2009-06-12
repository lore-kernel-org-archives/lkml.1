Return-Path: <linux-kernel-owner+w=401wt.eu-S1762616AbZFLAxo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762616AbZFLAxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 20:53:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbZFLAxd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 20:53:33 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:54766 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753860AbZFLAxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 20:53:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18993.42761.401143.92106@cargo.ozlabs.ibm.com>
Date: Fri, 12 Jun 2009 10:53:29 +1000
From: Paul Mackerras <paulus@samba.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: origin tree build failure
In-Reply-To: <20090612102427.32582baa.sfr@canb.auug.org.au>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell writes:

> Subject: [PATCH] perfcounters: remove powerpc definitions of perf_counter_do_pending
> 
> Commit 925d519ab82b6dd7aca9420d809ee83819c08db2 ("perf_counter:
> unify and fix delayed counter wakeup") added global definitions.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Paul Mackerras <paulus@samba.org>
