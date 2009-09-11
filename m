Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbZIKBpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbZIKBpn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZIKBpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:45:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:38509 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbZIKBpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:45:42 -0400
Subject: Re: [PATCH tracing/kprobes 0/7] tracing/kprobes: kprobe-based
 event tracer update and perf support
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, Jim Keniston <jkenisto@us.ibm.com>,
       "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
In-Reply-To: <20090911013332.GB16396@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090911013332.GB16396@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 10 Sep 2009 21:45:43 -0400
Message-Id: <1252633543.18996.61.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-11 at 03:33 +0200, Frederic Weisbecker wrote:

> It seems powerful enough to replace printk + kernel rebuild.
> 
> No need anymore to write some printk to debug, worrying,
> sweating, feeling guilty because we know we'll need yet another
> printk() after the reboot, and we even already know where while
> it is compiling.
> 
> We would build less kernels, then drink less coffee, becoming
> less nervous, more friendly. Everyone will offer flowers in
> the street, the icebergs will grow back and white bears will...
> 
> And eventually we'll be inspired enough to write perf love,
> the more than expected tool to post process ftrace "love" events.

OK Frederic,

Time for you to take a holiday!  ;-)

-- Steve

