Return-Path: <linux-kernel-owner+w=401wt.eu-S1761210AbZANMO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761210AbZANMO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 07:14:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbZANMOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 07:14:20 -0500
Received: from mail.gmx.net ([213.165.64.20]:59244 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753270AbZANMOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 07:14:19 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/YgkQajJjYwpXkEvUd4K2ilN3cYPTv5aEPjKWm6W
	ii2peJymVnOw+I
Subject: Re: [PATCH 0/2] prefer wakers -v2
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20090114114738.GH8625@elte.hu>
References: <20090114113917.199690328@chello.nl>
	 <20090114114738.GH8625@elte.hu>
Content-Type: text/plain
Date: Wed, 14 Jan 2009 13:14:15 +0100
Message-Id: <1231935255.29527.2.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 12:47 +0100, Ingo Molnar wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > OK, so lets try this again...
> 
> applied them to tip/sched/core:
> 
>  c4cddec: sched: prefer wakers
>  6a70714: sched: introduce avg_wakeup
> 
> Mike, what's your review/performance/interactivity verdict?

I saw nothing but good things with it.

	-Mike

