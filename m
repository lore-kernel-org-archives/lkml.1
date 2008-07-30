Return-Path: <linux-kernel-owner+w=401wt.eu-S1758703AbYG3INR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758703AbYG3INR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 04:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbYG3IM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 04:12:59 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56547 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758893AbYG3IM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 04:12:57 -0400
Date: Wed, 30 Jul 2008 09:00:32 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Peter Zijlstra <peterz@infradead.org>, Bill Gatliff <bgat@billgatliff.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, vatsa@linux.vnet.ibm.com,
       efault@gmx.de, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: Fwd: Commit 76a2a6ee8a0660a29127f05989ac59ae1ce865fa breaks PXA270 (at least)?
Message-ID: <20080730080032.GC2274@flint.arm.linux.org.uk>
References: <20080729223105.GK10982@flint.arm.linux.org.uk> <20080729154605.d540cf6d.akpm@linux-foundation.org> <20080729225623.GO10982@flint.arm.linux.org.uk> <1217401810.6364.3.camel@twins> <1217404554.6364.18.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217404554.6364.18.camel@twins>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 09:55:54AM +0200, Peter Zijlstra wrote:
> Sorry - that's only relevant for HAVE_UNSTABLE_SCHED_CLOCK and x86 seems
> to be the only one using that (which just shows the platforms quality
> </sarcasm>).

Can you please copy Bill on your responses.  I may not be around
for most of today, whereas I'm sure Bill would be willing to test
any patches...
