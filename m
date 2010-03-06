Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab0CFBhk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 20:37:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:52221 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721Ab0CFBhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 20:37:39 -0500
X-Authority-Analysis: v=1.0 c=1 a=8W9z7igzDIkA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=z6gsHLkEAAAA:8 a=DxKr-A-JilJpJ3WJfEIA:9 a=yMRc3Psn58f8kry48kF405uqoHMA:4 a=PUjeQqilurYA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH][RFC] ftrace: add tracing_thresh support to
 function_graph tracer (v3)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Timothy.Bird@am.sony.com
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4B918EE0.9020501@am.sony.com>
References: <1267234355.6328.155.camel@gandalf.stny.rr.com>
	 <4B918EE0.9020501@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 05 Mar 2010 20:37:37 -0500
Message-ID: <1267839457.10871.1787.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-03-05 at 15:08 -0800, Timothy.Bird@am.sony.com wrote:
> On 02/26/2010 05:32 PM, Steven Rostedt wrote:
> > Can you take look at this patch, and if you agree, can you give it your
> > ACK?  Applying this on top of my pull request gives a nice output:
> 
> 
> Steven, Frederic...
> 
> What happened with this?  Did it make it into anyone's
> tree?  Last I saw, the response was favorable, but I don't
> see it in Linus' tree, and I'd hate to miss the merge window.

Ah thanks for the reminder. I'll pull it in now with a few other patches
I'm working on.

-- Steve


