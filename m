Return-Path: <linux-kernel-owner+w=401wt.eu-S1753177AbXBKKmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177AbXBKKmj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 05:42:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbXBKKmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 05:42:39 -0500
Received: from ns1.suse.de ([195.135.220.2]:42478 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753174AbXBKKmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 05:42:22 -0500
From: Andi Kleen <ak@suse.de>
To: Ralf Baechle <ralf@linux-mips.org>
Subject: Re: -mm merge plans for 2.6.21
Date: Sun, 11 Feb 2007 11:37:45 +0100
User-Agent: KMail/1.9.5
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>, linux-mips@linux-mips.org,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@openvz.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
References: <20070208150710.1324f6b4.akpm@linux-foundation.org> <20070210102205.GB8145@osiris.boeblingen.de.ibm.com> <20070210210557.GA9116@linux-mips.org>
In-Reply-To: <20070210210557.GA9116@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111137.46344.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 February 2007 22:05, Ralf Baechle wrote:
> On Sat, Feb 10, 2007 at 11:22:05AM +0100, Heiko Carstens wrote:
> 
> > Which remembers me that I think that MIPS is using the non-compat version
> > of sys_epoll_pwait for compat syscalls. But maybe MIPS doesn't need a compat
> > syscall for some reason. Dunno.
> 
> Which reminds me that x86_64 i386 compat doesn't wire up sys_epoll_pwait ;-)

Added thanks.

-Andi
