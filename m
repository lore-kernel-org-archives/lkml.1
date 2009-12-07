Return-Path: <linux-kernel-owner+w=401wt.eu-S935162AbZLGUdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935162AbZLGUdr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934913AbZLGUdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:33:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35043 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934525AbZLGUdo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:33:44 -0500
Date: Mon, 7 Dec 2009 21:33:28 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
Message-ID: <20091207203328.GA4038@jolsa.mzk.cz>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
 <1259082845.22249.1110.camel@gandalf.stny.rr.com>
 <20091124211423.GE5071@nowhere>
 <20091125084525.GA1940@jolsa.lab.eng.brq.redhat.com>
 <20091204104616.GC1931@jolsa.lab.eng.brq.redhat.com>
 <20091207202146.GE5049@nowhere>
 <1260217585.3518.1.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260217585.3518.1.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 03:26:25PM -0500, Steven Rostedt wrote:
> On Mon, 2009-12-07 at 21:21 +0100, Frederic Weisbecker wrote:
> 
> > Steven has done some tests and it looks like you were right, the
> > problem comes from the seq_file, not the trace_seq.
> > 
> > Steve, any news about it?
> 
> Hehe, I got this message a second after I posted the series to fix the
> issue.
> 
> I had it done last week, but I needed to finish testing today before
> sending it.
> 
> -- Steve
> 
> 
cool :) I'll check it

thanks,
jirka
