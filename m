Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab0BQR2u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 12:28:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0BQR2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 12:28:49 -0500
X-Authority-Analysis: v=1.0 c=1 a=Hp-5F7rRw9MA:10 a=w8CfPoJMAJT1HY9uBz4A:9 a=-Jl73lrhKVGXNRTTLaAHilaDfv0A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: undefined reference to `.L1485'
From: Steven Rostedt <rostedt@goodmis.org>
To: Naveed Cochinwala <naveed_coch@yahoo.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <123540.36996.qm@web112508.mail.gq1.yahoo.com>
References: <123540.36996.qm@web112508.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 17 Feb 2010 12:28:47 -0500
Message-ID: <1266427727.24271.146.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 19:35 -0800, Naveed Cochinwala wrote:
> When I try to compile the latest stable kernel (2.6.32.8), here is the error I get
> ~/linux-2.6.32.8/include/trace/events/kmem.h:47: undefined reference to `.L1485'

Could you email me your .config file that caused this error.

> 
> Some info on my existing environment/machine:
> The kernel that I have installed on my machine is: 2.6.9-42.EL
> x86 machine.
> gcc (GCC) 3.4.6 20060404 (Red Hat 3.4.6-3)

That's an old compiler, I'll try it first with a more recent one, then
if it doesn't error, I try it with that one.

-- Steve


