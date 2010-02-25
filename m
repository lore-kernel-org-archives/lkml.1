Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932825Ab0BYQO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 11:14:59 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:53750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932705Ab0BYQO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 11:14:58 -0500
X-Authority-Analysis: v=1.0 c=1 a=eNVLYnTlQjUA:10 a=7U3hwN5JcxgA:10 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=kOU8fZ8KLaskL6z07L0A:9 a=jexw9V_xGMvIL7zq5QtybfKvmOYA:4 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 05/07] kernel.h trace cleanup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100225154322.GA2686@darkstar>
References: <20100225154322.GA2686@darkstar>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 11:14:56 -0500
Message-ID: <1267114496.6328.3.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-25 at 23:43 +0800, Dave Young wrote:
> Cleanup kernel.h trace related stuff, move to linux/trace.h
> 
> As Steven Rostedt said, trace stuff should be as convenient as printk,
> so include trace.h in kernel.h for convinience.
> 
> Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
> ---
>  include/linux/kernel.h |  137 -----------------------------------------------
>  include/linux/trace.h  |  141 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 142 insertions(+), 136 deletions(-)
> 

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> --- /dev/null	1970-01-01 00:00:00.000000000 +0000


