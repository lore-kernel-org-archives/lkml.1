Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZBFHF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZBFHF7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 02:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbZBFHFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 02:05:47 -0500
Received: from gate.crashing.org ([63.228.1.57]:38510 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753402AbZBFHFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 02:05:46 -0500
Subject: Re: [PATCH 1/2] ftrace, powerpc: replace debug macro with proper
 pr_deug
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Michael Neuling <mikey@neuling.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20090206060527.148611255@goodmis.org>
References: <20090206060328.181057235@goodmis.org>
	 <20090206060527.148611255@goodmis.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 18:05:12 +1100
Message-Id: <1233903912.4612.120.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-02-06 at 01:03 -0500, Steven Rostedt wrote:
> plain text document attachment
> (0001-ftrace-powerpc-replace-debug-macro-with-proper-pr_.patch)
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: cleanup
> 
> The PowerPC ftrace code uses a hacked up DEBUGP macro for prints.
> This patch converts it to the standard pr_debug.
>
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

Want me to go through powerpc tree or you'll merge via Ingo ?



