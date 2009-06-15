Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbZFONaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbZFONaQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 09:30:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751181AbZFONaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 09:30:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52963 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZFONaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 09:30:03 -0400
Message-ID: <4A364C74.3040006@zytor.com>
Date: Mon, 15 Jun 2009 06:28:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
References: <20090615024520.786814520@intel.com> <4A35BD7A.9070208@linux.vnet.ibm.com> <20090615042753.GA20788@localhost> <Pine.LNX.4.64.0906151341160.25162@sister.anvils> <20090615140019.4e405d37@lxorguk.ukuu.org.uk> <20090615132934.GE31969@one.firstfloor.org>
In-Reply-To: <20090615132934.GE31969@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 
> That said the real tests of this can be only done with test suites
> really, these errors tend to not happen quickly. 
> 

What's far more important, quite frankly, is harmlessness regression
testing.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

