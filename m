Return-Path: <linux-kernel-owner+w=401wt.eu-S939491AbZDJSPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939491AbZDJSPM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 14:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939358AbZDJSOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 14:14:48 -0400
Received: from www.tglx.de ([62.245.132.106]:42685 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766015AbZDJSOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 14:14:46 -0400
Date: Fri, 10 Apr 2009 20:13:44 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
In-Reply-To: <1239385015.3169.15.camel@ht.satnam>
Message-ID: <alpine.LFD.2.00.0904102012230.21577@localhost.localdomain>
References: <1239385015.3169.15.camel@ht.satnam>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 10 Apr 2009, Jaswinder Singh Rajput wrote:
> Impact: fix overflow

Nothing to fix there.
 
> Constant 0x123456789abcdef0 is so big for a long.

Really ? long is 64bit on a 64bit machine.

Thanks,

	tglx

