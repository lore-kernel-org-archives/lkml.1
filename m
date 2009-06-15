Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbZFODVq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbZFODVq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 23:21:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755493AbZFODSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 23:18:30 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:38393 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756751AbZFODS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 23:18:28 -0400
Message-ID: <4A35BD7A.9070208@linux.vnet.ibm.com>
Date: Mon, 15 Jun 2009 08:48:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.21 (X11/20090409)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Mel Gorman <mel@csn.ul.ie>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 00/22] HWPOISON: Intro (v5)
References: <20090615024520.786814520@intel.com>
In-Reply-To: <20090615024520.786814520@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Hi all,
> 
> Comments are warmly welcome on the newly introduced uevent code :)
> 
> I hope we can reach consensus in this round and then be able to post
> a final version for .31 inclusion.

Isn't that too aggressive? .31 is already in the merge window.

-- 
	Balbir
