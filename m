Return-Path: <linux-kernel-owner+w=401wt.eu-S1761642AbXJDVAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761642AbXJDVAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 17:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757813AbXJDVAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 17:00:39 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40917
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756974AbXJDVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 17:00:39 -0400
Date: Thu, 04 Oct 2007 14:00:38 -0700 (PDT)
Message-Id: <20071004.140038.126762674.davem@davemloft.net>
To: val@nmt.edu
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, rrbranco@br.ibm.com,
       twichell@us.ibm.com, ycai@us.ibm.com
Subject: Re: [ANNOUNCE] ebizzy 0.2 released
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071004204201.GB6090@rainbow>
References: <20070823010626.GC11402@rainbow>
	<20070930.172703.79041329.davem@davemloft.net>
	<20071004204201.GB6090@rainbow>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Henson <val@nmt.edu>
Date: Thu, 4 Oct 2007 14:42:01 -0600

> Ebizzy is based on a real web application server and does do things
> that are fairly common in such applications (multithreaded memory
> allocation and memory access), but it ignores networking for two
> reasons: the network stack was not the bottleneck for this workload,
> the VM was, and really good network benchmarks already exist. :)
> ebizzy is not useful to networking (or file systems) developer, but it
> has been used to improve malloc() behavior in glibc and to test VMA
> handling optimizations.

Thanks for clarifying all of this Valerie.
