Return-Path: <linux-kernel-owner+w=401wt.eu-S1760349AbXHEFFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760349AbXHEFFu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 01:05:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbXHEFFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 01:05:42 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:45391 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbXHEFFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 01:05:41 -0400
Subject: Re: [BUG  RT] - rcupreempt.c:133 on 2.6.23-rc1-rt7
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1186289484.636.5.camel@localhost.localdomain>
References: <1186289484.636.5.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 01:05:32 -0400
Message-Id: <1186290332.636.8.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-08-05 at 00:51 -0400, Steven Rostedt wrote:

> I don't have time to look further now, and it's something that isn't
> easily reproducible (Well, it happened once out of two boots). If you
> need me to look further, or need a config or dmesg (I have both), then
> just give me a holler.

Silly me. FYI, I was running with !PREEMPT_RT, but with Hard and
Softirqs as threads.  Must have copied the wrong config over :-/

-- Steve


