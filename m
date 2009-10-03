Return-Path: <linux-kernel-owner+w=401wt.eu-S1756385AbZJCA5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbZJCA5e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 20:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZJCA5d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 20:57:33 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:46598 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZJCA5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 20:57:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cSOZeAih2qQJ+gWTxeKRYBnkAdsv+s+kCZPS04hnF7UNtfojWLrBuH6+3ZvDn96Pdj
         4TsXIQci6T74UvRRdrfp2ejHnZ7NQ1GPwKFf5LZEAMUstiyBjJqKhmlvN1jl4hnI6LP7
         zyVZEVrxyDLsK9GkWmUYJGe7kba39FysyTfWE=
Date: Sat, 3 Oct 2009 02:57:33 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH tracing/kprobes 0/3] tracing/kprobes: kprobe-tracer
	updates
Message-ID: <20091003005732.GB4828@nowhere>
References: <20090925181952.10157.9975.stgit@omoto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925181952.10157.9975.stgit@omoto>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 11:19:52AM -0700, Masami Hiramatsu wrote:
> Hi Frederic,
> 
> Here is a few updates for kprobe-tracer which fix reported bugs and
> is for catching up the latest ftrace.
> 
>  - Use dynamic percpu profiling buffer patch is for catching up
>    the latest ftrace change.
>  - Checking the result of create_event_dir() patch improves ftrace
>    code pointed by Li Zefan (thanks!).
>  - Add VIA instructions to x86 insn decoder patch fixes decoding
>    bug reported by Ingo Molnar (thanks!).
> 
> Soon after this series, I'll send perf-kprobe patch series.
> 
> Thank you,


Applied, thanks Masami!

