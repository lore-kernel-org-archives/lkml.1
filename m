Return-Path: <linux-kernel-owner+w=401wt.eu-S1754302AbZIGSrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754302AbZIGSrY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 14:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753082AbZIGSrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 14:47:24 -0400
Received: from fifo99.com ([67.223.236.141]:53583 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751326AbZIGSrX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 14:47:23 -0400
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
From: Daniel Walker <dwalker@fifo99.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Buesch <mb@bu3sch.de>, Con Kolivas <kernel@kolivas.org>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>, Felix Fietkau <nbd@openwrt.org>
In-Reply-To: <20090907182629.GA3484@elte.hu>
References: <20090906205952.GA6516@elte.hu>
	 <200909071716.57722.mb@bu3sch.de>  <20090907182629.GA3484@elte.hu>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 11:47:36 -0700
Message-Id: <1252349256.2139.26.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-07 at 20:26 +0200, Ingo Molnar wrote:
> That's interesting. I tried to reproduce it on x86, but the profile 
> does not show any scheduler overhead at all on the server:

If the scheduler isn't running the task which causes the lower
throughput , would that even show up in profiling output?

Daniel

