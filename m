Return-Path: <linux-kernel-owner+w=401wt.eu-S1030811AbXCNJmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030811AbXCNJmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030826AbXCNJmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:42:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:54814 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1030811AbXCNJmO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:42:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19e3jV844hegqLVsGEfYoR/D8ZJOXc7OX7UHTBENT
	lB1f5DrJmjHFvV
Subject: Re: [PATCH] [RSDL-0.30] sched: rsdl improve latencies with 
	differential nice
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Al Boldi <a1426z@gawab.com>, Andrew Morton <akpm@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703142026.05016.kernel@kolivas.org>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703140231.28314.kernel@kolivas.org>
	 <1173863615.7822.86.camel@Homer.simpson.net>
	 <200703142026.05016.kernel@kolivas.org>
Content-Type: text/plain
Date: Wed, 14 Mar 2007 10:42:10 +0100
Message-Id: <1173865330.7822.90.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-14 at 20:25 +1100, Con Kolivas wrote:

> No don't. It's buggy and you missed the warning. Boy were you lucky I was 
> looking right now.

I'll wait for a .31 and construct a 2.6.21-rc3 (isolation) test-tree
from that.

	-Mike

