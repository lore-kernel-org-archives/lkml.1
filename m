Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367Ab0BYPf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:35:28 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63688 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759358Ab0BYPfZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:35:25 -0500
X-Authority-Analysis: v=1.0 c=1 a=ghyrhsaLHwwA:10 a=7U3hwN5JcxgA:10 a=yPCof4ZbAAAA:8 a=IM5Gmz4YiYqMR86kU1sA:9 a=EO5BD_GzD8xoevj9m40ah7qZNO0A:4 a=7DSvI1NPTFQA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH -tip 4/5] tracing: return accurate value for
 print_graph_prologue
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Wenji Huang <wenji.huang@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100225041835.GF7491@nowhere>
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com>
	 <1266997226-6833-2-git-send-email-wenji.huang@oracle.com>
	 <1266997226-6833-3-git-send-email-wenji.huang@oracle.com>
	 <1266997226-6833-4-git-send-email-wenji.huang@oracle.com>
	 <20100225041835.GF7491@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 10:35:21 -0500
Message-ID: <1267112121.6328.1.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 05:18 +0100, Frederic Weisbecker wrote:
> On Wed, Feb 24, 2010 at 03:40:25PM +0800, Wenji Huang wrote:
> > Return TRACE_TYPE_HANDLED instead of zero to avoid confusion.
> > 
> > Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> > ---


> It's not a big deal because there will always be something
> else to print after the prologue, and this will fail too
> and then return the error.

I'll apply the rest of the series and leave this patch out.

-- Steve


