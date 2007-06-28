Return-Path: <linux-kernel-owner+w=401wt.eu-S1765265AbXF1Ujv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765265AbXF1Ujv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752413AbXF1Ujk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:39:40 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:43614 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758226AbXF1Ujj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:39:39 -0400
Date: Thu, 28 Jun 2007 22:40:01 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>,
       chrisw@sous-sol.org, xen-devel@lists.xensource.com
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc6-mm1: Xen: WARNING: Absolute relocations present
Message-ID: <20070628204001.GA6087@stusta.de>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

<--  snip  -->

...
  RELOCS  arch/i386/boot/compressed/vmlinux.relocs
WARNING: Absolute relocations present
Offset     Info     Type     Sym.Value Sym.Name
c0101f80 020c6501   R_386_32 00000000  xen_irq_disable_direct_reloc
c0101f9a 0221ea01   R_386_32 00000000  xen_save_fl_direct_reloc
...

<--  snip  -->

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

