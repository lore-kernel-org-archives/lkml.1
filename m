Return-Path: <linux-kernel-owner+w=401wt.eu-S935790AbXGRX7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935790AbXGRX7e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 19:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760932AbXGRX70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 19:59:26 -0400
Received: from ns1.suse.de ([195.135.220.2]:60244 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760910AbXGRX70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 19:59:26 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [git patches] two warning fixes
Date: Thu, 19 Jul 2007 01:59:22 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, adaplas@gmail.com,
       linux-fbdev-devel@lists.sourceforge.net, benh@kernel.crashing.org
References: <20070718235504.GA9601@havoc.gtf.org>
In-Reply-To: <20070718235504.GA9601@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707190159.22654.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 01:55:04 Jeff Garzik wrote:
> 
> Please pull from 'warnings' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git warnings
> 
> to receive the following updates:
> 
>  drivers/video/aty/radeon_base.c |   23 ++++++++++++++++++-----
>  include/asm-x86_64/tlbflush.h   |    6 +++++-
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> Jeff Garzik (2):
>       drivers/video/aty/radeon_base: fix radeonfb_pci_register() err handling
>       [X86-64] make flush_tlb_kernel_range() a static inline function

I already got that patch queued. Why don't you send them through the maintainers?

-Andi
