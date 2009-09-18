Return-Path: <linux-kernel-owner+w=401wt.eu-S1754523AbZIRNve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523AbZIRNve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 09:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751195AbZIRNve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 09:51:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:58144 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbZIRNvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 09:51:33 -0400
Subject: Re: [PATCH 2/3][RESEND] tracing: remove max_tracer_type_len
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB32377.9020601@cn.fujitsu.com>
References: <4AB32364.7020602@cn.fujitsu.com>
	 <4AB32377.9020601@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 18 Sep 2009 09:51:35 -0400
Message-Id: <1253281895.20020.326.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 14:06 +0800, Li Zefan wrote:
> Limit the length of a tracer's name within 100 chars, and then we
> don't have to play with max_tracer_type_len.

What? You don't like my over-engineering? ;-)

> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks, I'll pull them.

Ingo, This patch series is mainly cleanups. Do we still have time to add
this for v2.6.32, or should we wait till 33?.

-- Steve


