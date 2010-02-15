Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab0BOClh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 21:41:37 -0500
Received: from gate.crashing.org ([63.228.1.57]:57571 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753614Ab0BOClg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 21:41:36 -0500
Subject: Re: [PATCH -mm 5/7] powerpc: use generic pci_set_dma_mask and
 pci_set_consistent_dma_mask
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-Reply-To: <20100215105606Y.fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1265967212-9126-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	 <1266190600.16346.74.camel@pasglop>
	 <20100215105606Y.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Feb 2010 13:41:27 +1100
Message-ID: <1266201687.16346.113.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-02-15 at 10:57 +0900, FUJITA Tomonori wrote:
> I guess it's easier if Andrew carries all the patches since some of
> the patches in this patchset depend on my other patches in -mm.

Fine with me.

Cheers,
Ben.


