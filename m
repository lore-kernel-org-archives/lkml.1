Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbYFMROk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbYFMROk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 13:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYFMRO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 13:14:29 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33599 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbYFMRO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 13:14:28 -0400
Date: Fri, 13 Jun 2008 10:13:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       jeremy@xensource.com, chrisw@sous-sol.org,
       virtualization@lists.osdl.org
Subject: Re: linux-next: Tree for June 13 (XEN)
Message-Id: <20080613101316.1c228fe7.randy.dunlap@oracle.com>
In-Reply-To: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
References: <20080613232214.394fd6fd.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


next-20080613 on x86_32 has lots of xen build errors like this:

linux-next-20080613/arch/x86/xen/mmu.c: In function 'drop_mm_ref':
linux-next-20080613/arch/x86/xen/mmu.c:759: error: implicit declaration of function 'xen_smp_call_function_mask'
make[2]: *** [arch/x86/xen/mmu.o] Error 1


---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
