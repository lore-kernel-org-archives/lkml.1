Return-Path: <linux-kernel-owner+w=401wt.eu-S1754559AbZIIXd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559AbZIIXd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:33:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753602AbZIIXd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:33:58 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:56629 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbZIIXd5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:33:57 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19112.15202.318732.299671@cargo.ozlabs.ibm.com>
Date: Thu, 10 Sep 2009 09:33:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.31
In-Reply-To: <alpine.LFD.2.01.0909091529530.7458@localhost.localdomain>
References: <alpine.LFD.2.01.0909091529530.7458@localhost.localdomain>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds writes:

> There's also a fair chunk of new debugging/peformance counter stuff: 
> memory leak detection ("kmemleak"), memory usage checking ("kmemcheck") 
> and performance counters ("perf_counter"). Those new debugging features 
> are not likely usable under any real load, but are good for finding kernel 
> bugs at a huge performance cost.

Just to be clear, that last sentence applies to kmemleak and
kmemcheck, but not perf_counters, right?

Paul.
