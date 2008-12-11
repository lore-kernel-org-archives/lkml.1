Return-Path: <linux-kernel-owner+w=401wt.eu-S1756863AbYLKSf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756863AbYLKSf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 13:35:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756093AbYLKSfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 13:35:48 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756074AbYLKSfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 13:35:47 -0500
Date: Thu, 11 Dec 2008 10:35:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, eranian@googlemail.com,
       dada1@cosmosbay.com, robert.richter@amd.com, arjan@infradead.org,
       hpa@zytor.com, a.p.zijlstra@chello.nl, paulus@samba.org,
       davem@davemloft.net
Subject: Re: [patch] Performance Counters for Linux, v3
Message-Id: <20081211103504.73ecabdd.akpm@linux-foundation.org>
In-Reply-To: <20081211155230.GA4230@elte.hu>
References: <20081211155230.GA4230@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Dec 2008 16:52:30 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> To: linux-kernel@vger.kernel.org
> Cc: Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Stephane Eranian <eranian@googlemail.com>, Eric Dumazet <dada1@cosmosbay.com>, Robert Richter <robert.richter@amd.com>, Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, "David S. Miller" <davem@davemloft.net>

Please copy perfctr-devel@lists.sourceforge.net on all this.  That is where
the real-world people who use these facilities on a regular basis hang out.
