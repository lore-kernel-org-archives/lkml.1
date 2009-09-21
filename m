Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZIUHLI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZIUHLI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 03:11:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbZIUHLC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 03:11:02 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:27119 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360AbZIUHLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 03:11:01 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH] sched: Simplify sys_sched_rr_get_interval() system call
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing <linux-kernel@vger.kernel.org>
In-Reply-To: <06d1b89ee15a0eef82d7.1253496713@mudlark.pw.nest>
References: <06d1b89ee15a0eef82d7.1253496713@mudlark.pw.nest>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 09:11:52 +0200
Message-Id: <1253517112.8439.137.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 01:31 +0000, Peter Williams wrote:
> # HG changeset patch
> # User Peter Williams <pwil3058@bigpond.net.au>
> # Date 1253495380 -36000
> # Node ID 06d1b89ee15a0eef82d7b9e8ed1ac20e6cf43661
> # Parent  067982df9f80206a7b49780f2235bde3b3249631
> sched: Simplify sys_sched_rr_get_interval() system call
> by removing the need for it to know details of scheduling classes.
> 
> Signed-off-by: Peter Williams <pwil3058@bigpond.net.au>

Looks good to me,

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

