Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZJAUmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZJAUmm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 16:42:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZJAUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 16:42:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50330
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752004AbZJAUml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 16:42:41 -0400
Date: Thu, 01 Oct 2009 13:43:00 -0700 (PDT)
Message-Id: <20091001.134300.206073034.davem@davemloft.net>
To: akpm@linux-foundation.org
CC: mingo@elte.hu, p.zijlstra@chello.nl, paulus@samba.org,
       linux-kernel@vger.kernel.org
Subject: status of 'perf' vmalloc bits?
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey guys, what is the status of the vmalloc_user() and 'perf'
mmap patches?

I am under the impression that the 'perf' folks have agreed upon
an implementation of the changes I need (split allocation scheme)
and that there were no voiced objections to the mm/vmalloc.c patch?

Sparc needs this to use 'perf' properly, so if this fix could go
in at some point I'd appreciate it :-)

Thanks!
