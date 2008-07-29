Return-Path: <linux-kernel-owner+w=401wt.eu-S1754765AbYG2BtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765AbYG2BtL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 21:49:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbYG2Bs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 21:48:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752011AbYG2Bs5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 21:48:57 -0400
Message-ID: <488E769D.6020902@redhat.com>
Date: Mon, 28 Jul 2008 21:47:09 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 11/24] x86: kernel/kprobes.c cleanup
References: <gustavo@las.ic.unicamp.br> <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-4-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-5-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-6-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-7-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-8-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-9-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-10-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-11-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
In-Reply-To: <1217279371-4410-12-git-send-email-gustavo@las.ic.unicamp.br>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gustavo F. Padovan wrote:
> Remove additional whitespaces.
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>

Thank you for cleanup!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> ---
>  arch/x86/kernel/kprobes.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
> index 6c27679..d3190dc 100644
> --- a/arch/x86/kernel/kprobes.c
> +++ b/arch/x86/kernel/kprobes.c
> @@ -30,14 +30,14 @@
>   *		<jkenisto@us.ibm.com> and Prasanna S Panchamukhi
>   *		<prasanna@in.ibm.com> added function-return probes.
>   * 2005-May	Rusty Lynch <rusty.lynch@intel.com>
> - * 		Added function return probes functionality
> + *		Added function return probes functionality
>   * 2006-Feb	Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp> added
> - * 		kprobe-booster and kretprobe-booster for i386.
> + *		kprobe-booster and kretprobe-booster for i386.
>   * 2007-Dec	Masami Hiramatsu <mhiramat@redhat.com> added kprobe-booster
> - * 		and kretprobe-booster for x86-64
> + *		and kretprobe-booster for x86-64
>   * 2007-Dec	Masami Hiramatsu <mhiramat@redhat.com>, Arjan van de Ven
> - * 		<arjan@infradead.org> and Jim Keniston <jkenisto@us.ibm.com>
> - * 		unified x86 kprobes code.
> + *		<arjan@infradead.org> and Jim Keniston <jkenisto@us.ibm.com>
> + *		unified x86 kprobes code.
>   */
>  
>  #include <linux/kprobes.h>

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

