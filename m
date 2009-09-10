Return-Path: <linux-kernel-owner+w=401wt.eu-S1754923AbZIJB4n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923AbZIJB4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 21:56:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754861AbZIJB4n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 21:56:43 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:65134 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754855AbZIJB4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 21:56:42 -0400
Subject: Re: [PATCH 2/2] ksym_tracer: Remove KSYM_SELFTEST_ENTRY
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090910014808.GB8450@nowhere>
References: <4AA857D8.9020906@cn.fujitsu.com>
	 <20090910014808.GB8450@nowhere>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 09 Sep 2009 21:56:44 -0400
Message-Id: <1252547804.18996.0.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-10 at 03:48 +0200, Frederic Weisbecker wrote:
> On Thu, Sep 10, 2009 at 09:35:20AM +0800, Li Zefan wrote:
> > The macro used to be used in both trace_selftest.c and
> > trace_ksym.c, but no longer, so remove it from header file.
> > 
> > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> 
> 
> Steve, I should better take this one. I'm currently working
> on the breakpoint tree and I prepare a pull request so I can
> bring it inside.

OK, I'll take patch 1, and you can take patch 2 ;-)

-- Steve


