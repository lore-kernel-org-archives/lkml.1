Return-Path: <linux-kernel-owner+w=401wt.eu-S1758702AbZLKPAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702AbZLKPAu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:00:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbZLKPAr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:00:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:40466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758583AbZLKPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:00:45 -0500
X-Authority-Analysis: v=1.0 c=1 a=gSC5VE2jCJUA:10 a=7U3hwN5JcxgA:10 a=yPCof4ZbAAAA:8 a=UZdbuvYJDVwc9a6knykA:9 a=XOe5ZsDZAUf6tTi0e_-2WUZmg6kA:4 a=7DSvI1NPTFQA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: add checks for printing graph irq
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Wenji Huang <wenji.huang@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20091211111946.GC5244@nowhere>
References: <1260524315-17807-1-git-send-email-wenji.huang@oracle.com>
	 <20091211111946.GC5244@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 11 Dec 2009 10:00:50 -0500
Message-ID: <1260543650.2146.358.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-11 at 12:19 +0100, Frederic Weisbecker wrote:
> On Fri, Dec 11, 2009 at 05:38:35PM +0800, Wenji Huang wrote:
> > Check return value of trace_seq_printf.
> > 
> > Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> > ---
> 
> 
> I'm applying it, I'll send the fix for the problem you've reported
> at the same time.

As for my comment to the patch. Please do not apply this.

Thanks,

-- Steve


