Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336Ab0BYP2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 10:28:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53832 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759190Ab0BYP2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 10:28:35 -0500
X-Authority-Analysis: v=1.0 c=1 a=P-qlfg_d7QYA:10 a=7U3hwN5JcxgA:10 a=omOdbC7AAAAA:8 a=felOhypXBMga5Wt44i0A:9 a=GoPUqnTi8z_ZmtPYUu43EHSurLMA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH] tracing: Remove CONFIG_TRACE_POWER from kernel config
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B84D50E.4070806@cn.fujitsu.com>
References: <4B84D50E.4070806@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 25 Feb 2010 10:27:32 -0500
Message-ID: <1267111652.24271.8876.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 15:28 +0800, Li Zefan wrote:
> The power tracer has been converted to power trace events.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/Kconfig |    9 ---------
>  1 files changed, 0 insertions(+), 9 deletions(-)

Applied, Thanks!

-- Steve


