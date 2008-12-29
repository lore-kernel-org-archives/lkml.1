Return-Path: <linux-kernel-owner+w=401wt.eu-S1752026AbYL2PSE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbYL2PSE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 10:18:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751241AbYL2PRy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 10:17:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38063 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbYL2PRx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 10:17:53 -0500
Date: Mon, 29 Dec 2008 16:17:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: apic.c declare pic_mode before they get used
Message-ID: <20081229151740.GC26672@elte.hu>
References: <1230562972.26564.1.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1230562972.26564.1.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0196]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


applied your patches to tip/x86/cleanups:

 cf3874b: x86_64: pci-gart_64.c iommu_fullflush should be static
 788983d: x86: efi.c declare add_efi_memmap before they get used
 fa0cf44: x86: io_apic.c io_apic_sync should be static
 8a4cfcf: x86: apic.c declare pic_mode before they get used

thanks,

	Ingo
