Return-Path: <linux-kernel-owner+w=401wt.eu-S1754857AbXFZGqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857AbXFZGqS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 02:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751147AbXFZGqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 02:46:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51410 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750832AbXFZGqH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 02:46:07 -0400
Date: Mon, 25 Jun 2007 23:45:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>
Cc: linux-kernel@vger.kernel.org, ak@suse.de, gregkh@suse.de, muli@il.ibm.com,
       suresh.b.siddha@intel.com, arjan@linux.intel.com, ashok.raj@intel.com,
       davem@davemloft.net, clameter@sgi.com
Subject: Re: [Intel IOMMU 00/10] Intel IOMMU support, take #2
Message-Id: <20070625234550.058635cb.akpm@linux-foundation.org>
In-Reply-To: <20070619213701.219910000@askeshav-devel.jf.intel.com>
References: <20070619213701.219910000@askeshav-devel.jf.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jun 2007 14:37:01 -0700 "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com> wrote:

> 	This patch supports the upcomming Intel IOMMU hardware
> a.k.a. Intel(R) Virtualization Technology for Directed I/O 
> Architecture

So...  what's all this code for?

I assume that the intent here is to speed things up under Xen, etc?  Do we
have any benchmark results to help us to decide whether a merge would be
justified?

Does it slow anything down?
