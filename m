Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZIHOpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZIHOpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 10:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751164AbZIHOpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 10:45:18 -0400
Received: from bu3sch.de ([62.75.166.246]:42996 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750722AbZIHOpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 10:45:18 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Date: Tue, 8 Sep 2009 16:45:16 +0200
User-Agent: KMail/1.9.9
Cc: Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
References: <20090906205952.GA6516@elte.hu> <20090907182629.GA3484@elte.hu> <20090908074825.GA11413@elte.hu>
In-Reply-To: <20090908074825.GA11413@elte.hu>
X-Move-Along: Nothing to see here. No, really... Nothing.
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909081645.18505.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 08 September 2009 09:48:25 Ingo Molnar wrote:
> Mind poking on this one to figure out whether it's all repeatable 
> and why that slowdown happens?

I repeated the test several times, because I couldn't really believe that
there's such a big difference for me, but the results were the same.
I don't really know what's going on nor how to find out what's going on.

-- 
Greetings, Michael.
