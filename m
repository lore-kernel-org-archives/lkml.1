Return-Path: <linux-kernel-owner+w=401wt.eu-S1755193AbZKCVWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbZKCVWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 16:22:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752201AbZKCVWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 16:22:19 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:9712 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbZKCVWT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com;5:1>);
	Tue, 3 Nov 2009 16:22:19 -0500
Message-Id: <4AF058BC0200005A00057F94@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 03 Nov 2009 14:22:20 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: <rostedt@goodmis.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@redhat.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/14] cpumask: simplify sched_rt.c
References: <200911031453.15350.rusty@rustcorp.com.au>
 <1257266509.26028.3343.camel@gandalf.stny.rr.com>
In-Reply-To: <1257266509.26028.3343.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11/3/2009 at 11:41 AM, in message
<1257266509.26028.3343.camel@gandalf.stny.rr.com>, Steven Rostedt
<rostedt@goodmis.org> wrote: 
> Greg,
> 
> I believe this was mostly your code. Can you review this change.
> 

Hi Steve,
  FYI: Looking now.  The diff hunk layout is a little confusing, so I need to think about it a little longer.

Kind Regards,
-Greg


