Return-Path: <linux-kernel-owner+w=401wt.eu-S1752781AbYL3Gcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752781AbYL3Gcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 01:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYL3Gcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 01:32:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56113 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYL3Gcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 01:32:45 -0500
Message-ID: <4959BFBA.5000205@kernel.org>
Date: Mon, 29 Dec 2008 22:29:14 -0800
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, joerg.roedel@amd.com, leo.duran@amd.com,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: amd_iommu_init.c iommu_enable and	iommu_enable_event_logging
 should be static
References: <1230567253.26564.14.camel@jaswinder.satnam>
In-Reply-To: <1230567253.26564.14.camel@jaswinder.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to tip:x86/cleanups:

Jaswinder Singh Rajput (4):
      x86: amd_iommu_init.c: iommu_enable and iommu_enable_event_logging
should be static
      x86: amd_iommu.c: prealloc_protection_domains should be static
      x86: genx2apic_phys.c: x2apic_send_IPI_self and init_x2apic_ldr
should be static
      x86: bios_uv.c: uv_systab should be static

Thanks!

	-hpa

