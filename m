Return-Path: <linux-kernel-owner+w=401wt.eu-S1755123AbXGGUNW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755123AbXGGUNW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 16:13:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752547AbXGGUNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 16:13:13 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:56151 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752694AbXGGUNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 16:13:12 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Sun, 8 Jul 2007 02:05:03 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: KII Keiichi <k-keiichi@bx.jp.nec.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Netdev <netdev@vger.kernel.org>, Joel Becker <joel.becker@oracle.com>,
       Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH -mm 8/9] netconsole: Update documentation for dynamic
 reconfigurability
In-Reply-To: <468FDC91.2080300@bx.jp.nec.com>
Message-ID: <Pine.LNX.4.64.0707080158420.3789@cselinux1.cse.iitk.ac.in>
References: <20070704110739.28520.5036.sendpatchset@cselinux1.cse.iitk.ac.in>
 <20070704110819.28520.50445.sendpatchset@cselinux1.cse.iitk.ac.in>
 <468CEAEC.7040102@bx.jp.nec.com> <Pine.LNX.4.64.0707051913001.19842@cselinux1.cse.iitk.ac.in>
 <468FDC91.2080300@bx.jp.nec.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Keiichi,

On Sun, 8 Jul 2007, KII Keiichi wrote:
> [...]
> I tested your patches on the x86 architecture and report the results.
> It is no problem except for the above problem.
> I think that it is useful to use configfs(especially, mkdir and rmdir because
> of adding/removing netconsole_target).
> 
> I am going to test the your next iteration patches on x86 and IA64
> architecutures. 

Thanks a lot for reviewing and testing this. I'll send out the next
iteration by tommorrow.

Thanks,
Satyam
