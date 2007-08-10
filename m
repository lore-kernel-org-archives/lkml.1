Return-Path: <linux-kernel-owner+w=401wt.eu-S933177AbXHJIx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177AbXHJIx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 04:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758874AbXHJIxv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 04:53:51 -0400
Received: from ozlabs.org ([203.10.76.45]:33980 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757621AbXHJIxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 04:53:50 -0400
From: Michael Neuling <mikey@neuling.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Documentation: fix getdelays.c example -l option and segv 
In-reply-to: <20070810013306.beaed37e.akpm@linux-foundation.org> 
References: <18240.1186734285@neuling.org> <20070810013306.beaed37e.akpm@linux-foundation.org>
Comments: In-reply-to Andrew Morton <akpm@linux-foundation.org>
   message dated "Fri, 10 Aug 2007 01:33:06 -0700."
X-Mailer: MH-E 8.0.3; nmh 1.2; GNU Emacs 21.4.1
Date: Fri, 10 Aug 2007 18:53:47 +1000
Message-ID: <20368.1186736027@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Fix a couple of minor issues with the getdelays.c example code. 
> 
> What issues?

-l option (loop) doesn't work and it seg faults in print_delayacct.

Mikey
