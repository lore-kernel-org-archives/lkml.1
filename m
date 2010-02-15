Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752684Ab0BOBks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 20:40:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab0BOBkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 20:40:47 -0500
Message-ID: <4B78A60B.3030807@redhat.com>
Date: Sun, 14 Feb 2010 20:40:27 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] tracing fixes
References: <20100214090913.GA26388@elte.hu>
In-Reply-To: <20100214090913.GA26388@elte.hu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Could you push this commit too?

5ecaafdbf44b1ba400b746c60c401d54c7ee0863
kprobes: Add mcount to the kprobes blacklist

Since this bug can be easily reproduced with kprobe-tracer.

Thank you,

Ingo Molnar wrote:
> Linus,
> 
> Please pull the latest tracing-fixes-for-linus git tree from:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus
> 
>  Thanks,
> 
> 	Ingo
> 
> ------------------>
> Heiko Carstens (1):
>       tracing/kprobes: Fix probe parsing
> 
> Lai Jiangshan (1):
>       tracing: Fix circular dead lock in stack trace
> 

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

