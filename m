Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZIKCdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZIKCdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 22:33:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZIKCdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 22:33:05 -0400
Received: from fifo99.com ([67.223.236.141]:57289 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbZIKCdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 22:33:03 -0400
Subject: Re: [PATCH tracing/kprobes 3/7] tracing/kprobes: Cleanup kprobe
 tracer code.
From: Daniel Walker <dwalker@fifo99.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
In-Reply-To: <20090910235322.22412.52525.stgit@dhcp-100-2-132.bos.redhat.com>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com>
	 <20090910235322.22412.52525.stgit@dhcp-100-2-132.bos.redhat.com>
Content-Type: text/plain
Date: Thu, 10 Sep 2009 19:33:31 -0700
Message-Id: <1252636411.30578.224.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 19:53 -0400, Masami Hiramatsu wrote:
> Simplify trace_probe to remove an union, and remove some redundant wrappers.
> And also, cleanup create_trace_probe() function.
> 


One single checkpatch issue in this one (whitespace).. The rest of the
patch set appears to be clean tho ..

Daniel

