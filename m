Return-Path: <linux-kernel-owner+w=401wt.eu-S1764461AbYF0V4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764461AbYF0V4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764002AbYF0Vwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:52:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765545AbYF0Vwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:52:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Various x86 syscall mechanisms
In-Reply-To: Jeremy Fitzhardinge's message of  Friday, 27 June 2008 14:45:16 -0700 <48655F6C.7000409@goop.org>
References: <485C2875.2050204@goop.org>
	<20080627204954.166D0154077@magilla.localdomain>
	<48655F6C.7000409@goop.org>
X-Antipastobozoticataclysm: When George Bush projectile vomits antipasto on the Japanese.
Message-Id: <20080627215248.6E9C6154058@magilla.localdomain>
Date: Fri, 27 Jun 2008 14:52:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > [...] "int $0x80" for 32-bit
> > syscalls made from 64-bit tasks on CONFIG_IA32_EMULATION kernels (intended
> > for valgrind).
> 
> Hm, I think that's a post-facto rationalization.  

It was my recollection of something Andi had said about why it was there.
My recollections are not a reliable source of accurate information.

> Thanks for the clarifying overview.  I've been piecing my understanding 
> together as I've been getting 64-bit pvops Xen working, and trying to 
> fit what it has to do to implement all these instructions and mode 
> combinations, and it looks like I'm about right.

I'm always glad to help.


Thanks,
Roland
