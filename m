Return-Path: <linux-kernel-owner+w=401wt.eu-S1759833AbXEJAnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759833AbXEJAnJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:43:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbXEJAm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:42:57 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:56604 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756904AbXEJAm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:42:56 -0400
Date: Wed, 9 May 2007 17:42:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Miller <davem@davemloft.net>, clameter@sgi.com, mpm@selenic.com,
       linux-kernel@vger.kernel.org
Subject: Re: + fix-spellings-of-slab-allocator-section-in-init-kconfig.patch
 added to -mm tree
Message-Id: <20070509174238.b4152887.akpm@linux-foundation.org>
In-Reply-To: <46412BB5.1060605@yahoo.com.au>
References: <Pine.LNX.4.64.0705081746500.16914@schroedinger.engr.sgi.com>
	<20070509012725.GZ11115@waste.org>
	<Pine.LNX.4.64.0705081828300.17376@schroedinger.engr.sgi.com>
	<20070508.185141.85412154.davem@davemloft.net>
	<46412BB5.1060605@yahoo.com.au>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 May 2007 12:02:29 +1000
Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> BTW, we _really_ should be doing RCU properly in slob, because you
> technically can't noop RCU on UP (even though the current users may be
> safe...).
> 
> Patch attached to do that.

Does it work?
