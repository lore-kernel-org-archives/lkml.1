Return-Path: <linux-kernel-owner+w=401wt.eu-S1756367AbXD2K6h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756367AbXD2K6h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 06:58:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756345AbXD2K6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 06:58:14 -0400
Received: from mail38.syd.optusnet.com.au ([211.29.133.67]:45953 "EHLO
	mail38.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756365AbXD2K6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 06:58:10 -0400
From: Con Kolivas <kernel@kolivas.org>
To: tglx@linutronix.de
Subject: Re: [patch] CFS scheduler, -v6
Date: Sun, 29 Apr 2007 20:53:36 +1000
User-Agent: KMail/1.9.5
Cc: Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@elte.hu>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>, caglar@pardus.org.tr,
       Mark Lord <lkml@rtr.ca>, Zach Carter <linux@zachcarter.com>,
       buddabrod <buddabrod@gmail.com>
References: <20070425214704.GA32572@elte.hu> <20070429071627.GC23638@1wt.eu> <1177842654.5791.85.camel@localhost.localdomain>
In-Reply-To: <1177842654.5791.85.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704292053.37121.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 April 2007 20:30, Thomas Gleixner wrote:
> As a sidenote: I really wonder if anybody noticed yet, that the whole
> CFS / SD comparison is so ridiculous, that it is not even funny anymore.
> CFS modifies the scheduler and nothing else, SD fiddles all over the
> kernel in interesting ways.

This is a WTF if ever I saw one.

-- 
-ck
