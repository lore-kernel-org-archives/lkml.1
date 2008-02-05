Return-Path: <linux-kernel-owner+w=401wt.eu-S1762983AbYBEVl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762983AbYBEVl5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbYBEVlL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:41:11 -0500
Received: from neuf-infra-smtp-out-sp604006av.neufgp.fr ([84.96.92.121]:51457
	"EHLO neuf-infra-smtp-out-sp604006av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762772AbYBEVlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:41:09 -0500
Message-ID: <47A8CB3C.1090101@cosmosbay.com>
Date: Tue, 05 Feb 2008 21:46:52 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de, hpa@zytor.com
Subject: Re: [patch] x86: add code to dump the (kernel) page tables for visual
 inspection
References: <20080204222641.4488e6a7@laptopd505.fenrus.org>
In-Reply-To: <20080204222641.4488e6a7@laptopd505.fenrus.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven a écrit :
> Subject: x86: add code to dump the (kernel) page tables for visual inspection by kernel developers
> From: Arjan van de Ven <arjan@linux.intel.com>
> 
> This patch adds code to the kernel to have an (optional)
> /proc/kernel_page_tables debug file that basically dumps the kernel
> pagetables; this allows us kernel developers to verify that nothing fishy is
> going on and that the various mappings are set up correctly. This was quite
> useful in finding various change_page_attr() bugs, and is very likely to be
> useful in the future as well.
> 

Seems nice Arjan, but could we also add NUMA information ?

