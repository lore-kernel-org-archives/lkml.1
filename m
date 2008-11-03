Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYKCPcf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYKCPcf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 10:32:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754033AbYKCPc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 10:32:27 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:45199 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbYKCPc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 10:32:26 -0500
Date: Mon, 3 Nov 2008 15:31:54 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: next-20081103: arch/arm/kernel/elf.c:30: error: 'e_flags' undeclared
Message-ID: <20081103153154.GC26372@flint.arm.linux.org.uk>
References: <20081103183214.aac32543.sfr@canb.auug.org.au> <20081103142801.GA3918@x200.localdomain> <18703.5082.59702.571742@harpo.it.uu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18703.5082.59702.571742@harpo.it.uu.se>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 04:08:10PM +0100, Mikael Pettersson wrote:
> Alexey Dobriyan writes:
>  > s/e_flags/eflags/ but I'm not sure.
> 
> Correct. I sent the fixup patch below to rmk and the linux arm mailing
> list yesterday, but I guess it hasn't found it's way to linux-next yet:

I committed the fix yesterday, but I haven't pushed my tree out yet.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
