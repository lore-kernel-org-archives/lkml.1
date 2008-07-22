Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbYGVOJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbYGVOJp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 10:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750831AbYGVOJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 10:09:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbYGVOJg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 10:09:36 -0400
Message-ID: <4885EA06.5070205@redhat.com>
Date: Tue, 22 Jul 2008 10:09:10 -0400
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Sebastian Siewior <bigeasy@linutronix.de>
CC: Steven Rostedt <srostedt@redhat.co>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] ftrace: copy + paste typo in asm/ftrace.h
References: <20080716213117.GA27890@www.tglx.de>
In-Reply-To: <20080716213117.GA27890@www.tglx.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Siewior wrote:
> Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>

Acked-by: Steven Rostedt <srostedt@redhat.com>

> ---
>  include/asm-x86/ftrace.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-x86/ftrace.h b/include/asm-x86/ftrace.h
> index c184441..5c68b32 100644
> --- a/include/asm-x86/ftrace.h
> +++ b/include/asm-x86/ftrace.h
> @@ -1,5 +1,5 @@
>  #ifndef _ASM_X86_FTRACE
> -#define _ASM_SPARC64_FTRACE
> +#define _ASM_X86_FTRACE
>  
>  #ifdef CONFIG_FTRACE
>  #define MCOUNT_ADDR		((long)(mcount))

