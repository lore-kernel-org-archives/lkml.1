Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZCWLBk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZCWLBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 07:01:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754692AbZCWLBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 07:01:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50687 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbZCWLB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 07:01:29 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Nikanth Karthikesan <knikanth@suse.de>
Subject: Re: ftrace not working?
Cc: kosaki.motohiro@jp.fujitsu.com, Ingo Molnar <mingo@elte.hu>,
       =?ISO-2022-JP?B?RnIbJEJxRXFTGyhCaWM=?= Weisbecker 
	<fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
In-Reply-To: <200903231408.35405.knikanth@suse.de>
References: <20090323083533.GE18837@elte.hu> <200903231408.35405.knikanth@suse.de>
Message-Id: <20090323200057.9027.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Mon, 23 Mar 2009 20:01:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 23 March 2009 14:05:33 Ingo Molnar wrote:
> > one thing to note:
> > | CPU0: Intel QEMU Virtual CPU version 0.9.1 stepping 03
> > | Testing tracer nop: PASSED
> >
> > so it's a Qemu session, right?
> >
> 
> Yes. qemu-kvm.

Ah, sorry. I don't know qemu and kvm at all ;)



