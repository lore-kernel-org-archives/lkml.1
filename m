Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYE3EQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYE3EQt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 00:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760039AbYE3EKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 00:10:51 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40946 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756600AbYE3EKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 00:10:50 -0400
Date: Thu, 29 May 2008 23:10:46 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyansky <maxk@qualcomm.com>
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       menage@google.com, rostedt@goodmis.org
Subject: Re: [PATCH] sched: Move cpu masks from kernel/sched.c into
 kernel/cpu.c
Message-Id: <20080529231046.c93c8097.pj@sgi.com>
In-Reply-To: <483F7DC3.9080705@qualcomm.com>
References: <1212085023-22284-1-git-send-email-maxk@qualcomm.com>
	<1212085023-22284-2-git-send-email-maxk@qualcomm.com>
	<20080529182634.e9146033.pj@sgi.com>
	<483F7DC3.9080705@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max K wrote:
> Luckily I have a ridiculously fast 8way box

I'm jealous ;).

> All the code is ifdefed under CONFIG_SMP

Ah - that's what I missed.  You're right.
I withdraw this objection.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
