Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbZKQPHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbZKQPHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 10:07:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754192AbZKQPHX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 10:07:23 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34892 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753786AbZKQPHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 10:07:21 -0500
Subject: Re: [PATCH] tracing: prevent build warning: 'ftrace_graph_buf'
 defined but not used
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B0254D7.2080503@cn.fujitsu.com>
References: <4AF24381.5060307@cn.fujitsu.com>
	 <20091105063917.GA4896@nowhere>  <4B0254D7.2080503@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 17 Nov 2009 10:07:25 -0500
Message-Id: <1258470445.22249.461.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-17 at 15:46 +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > On Thu, Nov 05, 2009 at 11:16:17AM +0800, Lai Jiangshan wrote:
> >> prevent build warning when !CONFIG_FUNCTION_GRAPH_TRACER
> >>
> >> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> 
> Hi, Ingo,
> 
> Could you apply this cleanup patch for -tip?
> 

Ah this is only in tip. OK, I'll add it to my queue anyway.

-- Steve


