Return-Path: <linux-kernel-owner+w=401wt.eu-S1753327AbZIUTRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327AbZIUTRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:17:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbZIUTRd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:17:33 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53623 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141AbZIUTRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:17:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BPUSqqH1NKYx6xili2UQtuRsZEfeeD+BCwrwXp0S8lKxuXW5rCmGRjFTJFHEu/yHat
         Abm5g9JwEyV1qgdmSpKJDhYBU2d449mnoa5o89EnO72ZYvzeYhwBkv5XJipHTG7qilXe
         CEw82eN+YCzyo5Jakdny16mRqS3RYBG0DgnA0=
Date: Mon, 21 Sep 2009 21:17:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Masami Hiramatsu <mhiramat@redhat.com>, postmaster@vger.kernel.org
Subject: Re: mailing list for trace users
Message-ID: <20090921191729.GE5018@nowhere>
References: <1253132182.20020.242.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253132182.20020.242.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16, 2009 at 04:16:22PM -0400, Steven Rostedt wrote:
> What are people's thoughts about creating a linux-trace-users mailing
> list on vger.kernel.org?
> 
> This would be a place for users of tracers and even perf. For asking
> questions about how to use the debugfs/tracing directory or the perf
> tool.
> 
> This will not be a place for kernel development. Patches for the tracing
> infrastructure should still go through LKML. This will be a place to ask
> how-to questions, or any other kind of help questions.
> 
> LKML can be quite intimidating, and it is not a place to ask help
> questions anyway. I think adding a linux-trace-users mailing list would
> be a good idea.
> 
> Thoughts?
> 
> -- Steve


Why not. That could also gather informations from LKML threads by
Cc'ing it while explaining how to use the tools in random discussions.

