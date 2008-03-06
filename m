Return-Path: <linux-kernel-owner+w=401wt.eu-S1765565AbYCFTNf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765565AbYCFTNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:13:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763123AbYCFTMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:12:44 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37255
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1761962AbYCFTMk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:12:40 -0500
Date: Thu, 06 Mar 2008 11:12:39 -0800 (PST)
Message-Id: <20080306.111239.85901884.davem@davemloft.net>
To: kamalesh@linux.vnet.ibm.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, apw@shadowen.org
Subject: Re: [BUILD_FAILURE] linux-next: Tree for March 6 build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <47CFF332.4040807@linux.vnet.ibm.com>
References: <20080306162606.970aefe1.sfr@canb.auug.org.au>
	<47CFF332.4040807@linux.vnet.ibm.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Date: Thu, 06 Mar 2008 19:05:46 +0530

> The kernel build fails with error
> 
> net/built-in.o(.toc1+0x2060): undefined reference to `udplite_statistics'
> net/built-in.o(.toc1+0x2100): undefined reference to `udplite_statistics'
> make: *** [.tmp_vmlinux1] Error 1

Please provide your .config so that others have a chance
to reproduce and fix this.

Thank you.
