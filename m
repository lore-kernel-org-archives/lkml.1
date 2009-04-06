Return-Path: <linux-kernel-owner+w=401wt.eu-S1756905AbZDFTYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905AbZDFTYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752635AbZDFTYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:24:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50578 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbZDFTYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:24:08 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
X-Fcc: ~/Mail/linus
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       systemtap-ml <systemtap@sources.redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH -tip 2/6 V4.2] x86: add arch-dep register and stack access
 API to ptrace
In-Reply-To: Masami Hiramatsu's message of  Friday, 3 April 2009 19:29:19 -0400 <49D69BCF.4080808@redhat.com>
References: <49D4F4DF.1040605@redhat.com>
	<20090402234835.GA6112@nowhere>
	<49D6331D.6000505@redhat.com>
	<20090403202004.3A2B1FC3AB@magilla.sf.frob.com>
	<49D680D0.1090701@redhat.com>
	<49D69BCF.4080808@redhat.com>
X-Windows: garbage at your fingertips.
Message-Id: <20090406192254.59713FC3E3@magilla.sf.frob.com>
Date: Mon,  6 Apr 2009 12:22:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have no comments about the patch, but the subject line is misleading
because this has nothing do with ptrace.  It's in asm/ptrace.h but it being
struct pt_regs does not really have anything to do with ptrace.


Thanks,
Roland
