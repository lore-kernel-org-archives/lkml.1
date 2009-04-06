Return-Path: <linux-kernel-owner+w=401wt.eu-S1757427AbZDFT5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427AbZDFT5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 15:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbZDFT5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 15:57:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:35161 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZDFT5d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 15:57:33 -0400
Message-ID: <49DA5EB1.5070004@redhat.com>
Date: Mon, 06 Apr 2009 15:57:37 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
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
References: <49D4F4DF.1040605@redhat.com>	<20090402234835.GA6112@nowhere>	<49D6331D.6000505@redhat.com>	<20090403202004.3A2B1FC3AB@magilla.sf.frob.com>	<49D680D0.1090701@redhat.com>	<49D69BCF.4080808@redhat.com> <20090406192254.59713FC3E3@magilla.sf.frob.com>
In-Reply-To: <20090406192254.59713FC3E3@magilla.sf.frob.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland McGrath wrote:
> I have no comments about the patch, but the subject line is misleading
> because this has nothing do with ptrace.  It's in asm/ptrace.h but it being
> struct pt_regs does not really have anything to do with ptrace.
> 

Hmm, so, it should be "x86: add arch-dep register and stack access API".

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

