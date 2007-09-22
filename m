Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbXIVEqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbXIVEqU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2007 00:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751178AbXIVEqN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Sep 2007 00:46:13 -0400
Received: from ozlabs.org ([203.10.76.45]:50018 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089AbXIVEqN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2007 00:46:13 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18164.40462.991761.909735@cargo.ozlabs.ibm.com>
Date: Sat, 22 Sep 2007 14:46:06 +1000
From: Paul Mackerras <paulus@samba.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Subject: Re: [patch 04/28] Add cmpxchg64 and cmpxchg64_local to powerpc
In-Reply-To: <20070827155524.827591009@polymtl.ca>
References: <20070827155234.062715780@polymtl.ca>
	<20070827155524.827591009@polymtl.ca>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers writes:

> Make sure that at least cmpxchg64_local is available on all architectures to use
> for unsigned long long values.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Acked-by: Paul Mackerras <paulus@samba.org>
