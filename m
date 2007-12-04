Return-Path: <linux-kernel-owner+w=401wt.eu-S1754421AbXLDPH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754421AbXLDPH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 10:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752557AbXLDPHT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 10:07:19 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:54579 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXLDPHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 10:07:18 -0500
Date: Tue, 4 Dec 2007 10:04:23 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Kevin Hilman <khilman@mvista.com>
cc: linux-rt-users@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -rt] ARM: compile fix for event tracing
In-Reply-To: <87fxyjruy8.fsf@vence.hilman.org>
Message-ID: <Pine.LNX.4.58.0712041003230.9066@gandalf.stny.rr.com>
References: <87fxyjruy8.fsf@vence.hilman.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Dec 2007, Kevin Hilman wrote:

> The cycles/usecs conversion macros should be dependent on
> CONFIG_EVENT_TRACE instead of CONFIG_LATENCY_TIMING.
>
> Signed-off-by: Kevin Hilman <khilman@mvista.com>
>
> --- a/include/asm-arm/timex.h
> +++ b/include/asm-arm/timex.h

Hi, thanks I'll apply this.

But please, in the future, state which version of the -rt patch you
applied this to.

Thanks,

-- Steve

