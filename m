Return-Path: <linux-kernel-owner+w=401wt.eu-S1752042AbZHZQm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042AbZHZQm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 12:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbZHZQm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 12:42:58 -0400
Received: from outbound-mail-155.bluehost.com ([67.222.39.35]:34194 "HELO
	outbound-mail-155.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751884AbZHZQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 12:42:57 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Z53CpKjVCnGDuja0tV4rZ6jMqvvAbGEB7Gudfa9haxAzFZMeyC3ph7mWFWD2N8z0S7Av/MperoPMvXUGodiW3jgGjP/6II3nnBGoW3f+cNtCxdehlJ8iYVxlplkrcyWN;
Date: Wed, 26 Aug 2009 09:42:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH] pci/intr_remapping: allocate irq_iommu on node -v3
Message-ID: <20090826094248.288274f3@jbarnes-g45>
In-Reply-To: <20090826073101.GD23435@elte.hu>
References: <4A84C13E.5050606@kernel.org>
	<4A84C190.1060005@kernel.org>
	<4A84C21A.4000705@kernel.org>
	<20090825114859.777be874@jbarnes-g45>
	<20090826073101.GD23435@elte.hu>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Aug 2009 09:31:01 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> 
> * Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> 
> > Ingo, I assume you took these two?
> 
> not yet - was waiting on noises from you and David. So the series 
> looks good to you from a PCI perspective and i can add your 
> acked-by? Would go into the IRQ tree.

Yeah, latest ones look good.

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
