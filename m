Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbXGCVtr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbXGCVtr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:49:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755133AbXGCVti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:49:38 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50288 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757971AbXGCVth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:49:37 -0400
Date: Tue, 3 Jul 2007 14:48:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] #if 0
 mm/backing-dev.c:congestion_wait_interruptible()
Message-Id: <20070703144843.4d402c32.akpm@linux-foundation.org>
In-Reply-To: <20070701202051.GG10869@stusta.de>
References: <20070701202051.GG10869@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Jul 2007 22:20:51 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> congestion_wait_interruptible() is no longer used.

We might as well just delete it?
