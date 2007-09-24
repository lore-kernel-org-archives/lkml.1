Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493AbXIXKId@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493AbXIXKId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 06:08:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752767AbXIXKI0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 06:08:26 -0400
Received: from E23SMTP04.au.ibm.com ([202.81.18.173]:38729 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712AbXIXKIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 06:08:25 -0400
Message-ID: <46F78C73.5040505@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2007 15:37:47 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.13 (X11/20070824)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: 2.6.23-rc7-mm1
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
In-Reply-To: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc7/2.6.23-rc7-mm1/
>
> - New git tree git-powerpc-galak.patch added to the -mm lineup: ppc32
>   things, mainly (Kumar Gala <galak@gate.crashing.org>)
>
>   
<snip>

Hi Andrew,

The link error for a PowerMac G5 (powerpc) is still seen with 
2.6.23-rc7-mm1,
and was reported for 2.6.23-rc6-mm1 (http://lkml.org/lkml/2007/9/19/62).

  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux.o
ld: dynreloc miscount for fs/built-in.o, section .opd
ld: can not edit opd Bad value
make: *** [vmlinux.o] Error 1

-- 

Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.

