Return-Path: <linux-kernel-owner+w=401wt.eu-S1759941AbXJLFBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759941AbXJLFBY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 01:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXJLFBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 01:01:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34082 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759488AbXJLFBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 01:01:08 -0400
Date: Fri, 12 Oct 2007 14:03:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-mm1
Message-Id: <20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 21:31:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 
> - I've been largely avoiding applying anything since rc8-mm2 in an attempt
>   to stabilise things for the 2.6.23 merge.
> 
On RHEL5/x86_64 environment,

==
[kamezawa@hannibal ref-2.6.23-mm1]$ make menuconfig
Makefile:456: /home/kamezawa/ref-2.6.23-mm1/arch//Makefile: No such file or directory
make: *** No rule to make target `/home/kamezawa/ref-2.6.23-mm1/arch//Makefile'.  Stop.
==

$(ARCH) cannot be detected automatically...

What information is useful for fixing this ?

Thanks,
-Kame

