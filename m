Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYGPCFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYGPCFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 22:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754635AbYGPCFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 22:05:44 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58048 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247AbYGPCFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 22:05:44 -0400
Date: Tue, 15 Jul 2008 22:05:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Vegard Nossum <vegard.nossum@gmail.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 4d3702b6 (post-v2.6.26): WARNING: at kernel/lockdep.c:2731
 check_flags (ftrace)
In-Reply-To: <19f34abd0807151855k22dc80d5tf3629da2e52ee6de@mail.gmail.com>
Message-ID: <Pine.LNX.4.58.0807152204130.20814@gandalf.stny.rr.com>
References: <19f34abd0807151855k22dc80d5tf3629da2e52ee6de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jul 2008, Vegard Nossum wrote:

>
> Hi,
>
> When booting 4d3702b6, I got this huge thing:
>
> Testing tracer wakeup: <4>------------[ cut here ]------------
> WARNING: at kernel/lockdep.c:2731 check_flags+0x123/0x160()
> Modules linked in:

Can you send me your config privately. Lockdep and ftrace dont always play
nice with each other.

Thanks,

-- Steve




