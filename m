Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbXFACBj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbXFACBj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 22:01:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbXFACBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 22:01:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbXFACBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 22:01:30 -0400
Message-ID: <465F7DEB.5090700@redhat.com>
Date: Thu, 31 May 2007 23:01:15 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
Organization: Red Hat Inc.
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.22-rc3-mm1
References: <20070530235823.793f00d9.akpm@linux-foundation.org>
In-Reply-To: <20070530235823.793f00d9.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc3/2.6.22-rc3-mm1/
>
> - Merged the convert-cpusets-to-container-infrastructure patches.  These
>   will probably be dropped and redone.
>
>
>
>   
<BIG SNIP>
>  x86 things
>
> +add-select-phylib-to-the-ucc_geth-kconfig-option.patch
> +m68k-parenthesis-balance.patch
> +msi-fix-the-ordering-of-msix-irqs.patch
> +msi-mask-the-msix-vector-before-we-unmap-it.patch
> +potential-parse-error-in-ifdef.patch
> +potential-parse-error-in-ifdef-fix.patch
> +potential-parse-error-in-ifdef-update.patch
> +pci_ids-update-patch-for-intel-ich9m.patch
> +x86-fix-oprofile-double-free-was-re-multiple-free.patch
>   
http://lkml.org/lkml/2007/5/30/565 fixes the above patch :-)

<BIG SNIP>

- Arnaldo
