Return-Path: <linux-kernel-owner+w=401wt.eu-S933152AbXC0Qje@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152AbXC0Qje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 12:39:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933143AbXC0Qje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 12:39:34 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53053 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152AbXC0Qjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 12:39:33 -0400
Subject: Re: 2.6.21-rc5-mm1
From: Badari Pulavarty <pbadari@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20070326205706.a750bb35.akpm@linux-foundation.org>
References: <20070326205706.a750bb35.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 09:39:33 -0800
Message-Id: <1175017173.16728.19.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-26 at 20:57 -0800, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm1/
> 


  LD      init/built-in.o
  LD      .tmp_vmlinux1
ld: section .vsyscall_1 [0000000000645400 -> 000000000064542e] overlaps
section .jiffies [0000000000645400 -> 0000000000645407]
ld: .tmp_vmlinux1: section .vsyscall_1 lma 0x645400 overlaps previous
sections
make: *** [.tmp_vmlinux1] Error 1


Thanks,
Badari

