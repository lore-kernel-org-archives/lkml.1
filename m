Return-Path: <linux-kernel-owner+w=401wt.eu-S1751864AbYBIHYu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbYBIHYu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 02:24:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbYBIHYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 02:24:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751485AbYBIHYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 02:24:38 -0500
Date: Fri, 8 Feb 2008 23:23:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [git pull] latency tracer
Message-Id: <20080208232306.6e8a8162.akpm@linux-foundation.org>
In-Reply-To: <20080208214522.GA31101@elte.hu>
References: <20080208214522.GA31101@elte.hu>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Feb 2008 22:45:22 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Linus, please pull the latency tracer tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched.git
> 
> Find the shortlog below.
> 
> This is the latency tracer from -rt

I've never seen any of this code before and googling several of the 
patch titles turns up this email and nothing else.

Could we get the patches out for review in the usual way please?

Bear in mind that people will actually want to understand how this
code works.   Particularly architecture maintainers.  (I assume it's
portable to non-x86?).

