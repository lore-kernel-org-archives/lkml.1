Return-Path: <linux-kernel-owner+w=401wt.eu-S1752775AbZIKCgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbZIKCgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 22:36:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbZIKCgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 22:36:18 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:45575 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585AbZIKCgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 22:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lM6S2cpjbY2Dfip+gts2YOkd3RVYFeULlkfiotEvftrCp6WhkC2tBtiKQGmQooeugt
         3qZmYlAjB98c9uurse7k435E3M9/ItC4BsnN9ohG/mF/U5D00yRdEAU8+JrlnTJoqprT
         J3vVr0/Gq7uXNZyIpga8vQlu5vf9jrVBDdCmQ=
Date: Fri, 11 Sep 2009 04:36:16 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Masami Hiramatsu <mhiramat@redhat.com>,
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
Subject: Re: [PATCH tracing/kprobes 3/7] tracing/kprobes: Cleanup kprobe
	tracer code.
Message-ID: <20090911023615.GC16396@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235322.22412.52525.stgit@dhcp-100-2-132.bos.redhat.com> <1252636411.30578.224.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252636411.30578.224.camel@desktop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 07:33:31PM -0700, Daniel Walker wrote:
> On Thu, 2009-09-10 at 19:53 -0400, Masami Hiramatsu wrote:
> > Simplify trace_probe to remove an union, and remove some redundant wrappers.
> > And also, cleanup create_trace_probe() function.
> > 
> 
> 
> One single checkpatch issue in this one (whitespace).. The rest of the
> patch set appears to be clean tho ..
> 
> Daniel
> 

Yep, no problem, I've fixed it while applying it.

Thanks.

