Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYFPFc6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYFPFc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:32:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYFPFct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:32:49 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43122 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbYFPFcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:32:48 -0400
Date: Mon, 16 Jun 2008 14:32:33 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm 00/24] VM pageout scalability improvements (V12)
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
In-Reply-To: <20080611223430.cba0f1b6.akpm@linux-foundation.org>
References: <20080611184214.605110868@redhat.com> <20080611223430.cba0f1b6.akpm@linux-foundation.org>
Message-Id: <20080616143034.78A1.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> qsbench, 4 processes, memory size tuned to threshold-of-swapping*1.1:
> 
> Mainline:
> 
> vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
> ./qsbench -p 4 -m 230  175.45s user 45.67s system 60% cpu 6:08.40 total
> 
> 2.6.26-rc5-mm3:
> 
> vmm:/home/akpm/qsbench> time ./qsbench -p 4 -m 230
> ./qsbench -p 4 -m 230  178.21s user 28.49s system 99% cpu 3:27.14 total

Where can I get this benchmark?

I found following URL. but it doesn't have -m option.
I guess it is too old ;)

http://lkml.org/lkml/2001/10/9/90


