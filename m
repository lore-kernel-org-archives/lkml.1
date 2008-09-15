Return-Path: <linux-kernel-owner+w=401wt.eu-S1754513AbYIOM3Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbYIOM3Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 08:29:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYIOM3B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 08:29:01 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:37864 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753310AbYIOM3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 08:29:00 -0400
Date: Mon, 15 Sep 2008 16:34:32 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       fmayhar@google.com, adobriyan@gmail.com, roland@redhat.com,
       tglx@linutronix.de
Subject: Re: + itimers-fix-itimer-many-thread-hang.patch added to -mm tree
Message-ID: <20080915123432.GA199@tv-sign.ru>
References: <200809122353.m8CNrCmR011310@imap1.linux-foundation.org> <20080914175040.GA819@tv-sign.ru> <20080914183932.GC28010@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080914183932.GC28010@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14, Ingo Molnar wrote:
>
> Oleg, the changes (with a few fixups from me) are in tip/master now

Great! This patch needs testing.

> (with a rough v2.6.28 target) - should i back them out for now, or do
> you think we can fix the items you noticed gradually?

Up to Frank and Roland, but I think we can make the cleanups incrementally,
on top of this patch.

Oleg.

