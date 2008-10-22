Return-Path: <linux-kernel-owner+w=401wt.eu-S1756066AbYJVVaS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbYJVVaS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 17:30:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYJVVaE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 17:30:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38764 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbYJVVaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 17:30:02 -0400
Date: Wed, 22 Oct 2008 14:28:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for October 22
Message-Id: <20081022142842.9a98d8f6.akpm@linux-foundation.org>
In-Reply-To: <20081022203838.f10065ec.sfr@canb.auug.org.au>
References: <20081022203838.f10065ec.sfr@canb.auug.org.au>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386 allnoconfig:

pci-dma.c:(.init.text+0x3381): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x3387): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x33a1): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x33a7): undefined reference to `forbid_dac'
pci-dma.c:(.init.text+0x33e7): undefined reference to `forbid_dac'
