Return-Path: <linux-kernel-owner+w=401wt.eu-S964908AbZLGU0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964908AbZLGU0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 15:26:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934913AbZLGU0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 15:26:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:55718 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934905AbZLGU0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 15:26:19 -0500
Subject: Re: [PATCH] tracing - fix function graph trace to properly display
 failed entries
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>, mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20091207202146.GE5049@nowhere>
References: <1259067458-27143-1-git-send-email-jolsa@redhat.com>
	 <1259082845.22249.1110.camel@gandalf.stny.rr.com>
	 <20091124211423.GE5071@nowhere>
	 <20091125084525.GA1940@jolsa.lab.eng.brq.redhat.com>
	 <20091204104616.GC1931@jolsa.lab.eng.brq.redhat.com>
	 <20091207202146.GE5049@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Mon, 07 Dec 2009 15:26:25 -0500
Message-Id: <1260217585.3518.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-07 at 21:21 +0100, Frederic Weisbecker wrote:

> Steven has done some tests and it looks like you were right, the
> problem comes from the seq_file, not the trace_seq.
> 
> Steve, any news about it?

Hehe, I got this message a second after I posted the series to fix the
issue.

I had it done last week, but I needed to finish testing today before
sending it.

-- Steve


