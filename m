Return-Path: <linux-kernel-owner+w=401wt.eu-S1751523AbYCFNgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523AbYCFNgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 08:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751040AbYCFNfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 08:35:54 -0500
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:50227 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751032AbYCFNfx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 08:35:53 -0500
Message-ID: <47CFF332.4040807@linux.vnet.ibm.com>
Date: Thu, 06 Mar 2008 19:05:46 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080227)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: [BUILD_FAILURE] linux-next: Tree for March 6 build failure
References: <20080306162606.970aefe1.sfr@canb.auug.org.au>
In-Reply-To: <20080306162606.970aefe1.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel build fails with error

net/built-in.o(.toc1+0x2060): undefined reference to `udplite_statistics'
net/built-in.o(.toc1+0x2100): undefined reference to `udplite_statistics'
make: *** [.tmp_vmlinux1] Error 1

-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
