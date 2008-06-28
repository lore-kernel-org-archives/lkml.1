Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYF1Qux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYF1Qux (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 12:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYF1Quq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 12:50:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:65468 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYF1Qup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 12:50:45 -0400
Date: Sat, 28 Jun 2008 12:50:42 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] migrate_timers: add comment, use spinlock_irq()
In-Reply-To: <20080628161856.GA7030@tv-sign.ru>
Message-ID: <Pine.LNX.4.58.0806281250090.17275@gandalf.stny.rr.com>
References: <20080628161856.GA7030@tv-sign.ru>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 28 Jun 2008, Oleg Nesterov wrote:

>
> Add the comment to explain why the double lock in migrate_timers()
> can't deadlock.

Thanks Oleg!

Signed-off-by: Steven Rostedt <srostedt@redhat.com>

-- Steve

