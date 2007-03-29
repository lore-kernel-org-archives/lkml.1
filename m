Return-Path: <linux-kernel-owner+w=401wt.eu-S934043AbXC2ISK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934043AbXC2ISK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 04:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934048AbXC2ISK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 04:18:10 -0400
Received: from mail.gmx.net ([213.165.64.20]:48691 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S934043AbXC2ISJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 04:18:09 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+4PCZKaga41KN2iXHZfZCuMfggF9yfgFR1PHkw0N
	cYmmhKaj/NvQCV
Subject: Re: [PATCH] sched: staircase deadline misc fixes
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <1175147455.6430.91.camel@Homer.simpson.net>
References: <200703290237.38777.kernel@kolivas.org>
	 <20070328184843.GA17420@elte.hu>  <200703290944.45888.kernel@kolivas.org>
	 <1175147455.6430.91.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 10:18:03 +0200
Message-Id: <1175156283.6430.143.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rereading to make sure I wasn't unclear anywhere...

On Thu, 2007-03-29 at 07:50 +0200, Mike Galbraith wrote:
>  
> I don't see what a < 95% load really means.

Egad.  Here I'm pondering the numbers and light load as I'm typing, and
my fingers (seemingly independent when mind wanders off) typed < 95% as
in not fully committed, instead of "light".

	-Mike

