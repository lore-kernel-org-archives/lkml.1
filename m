Return-Path: <linux-kernel-owner+w=401wt.eu-S1762681AbYEAQ3X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762681AbYEAQ3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 12:29:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757307AbYEAQ3P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 12:29:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54525 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753156AbYEAQ3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 12:29:14 -0400
Date: Thu, 1 May 2008 17:20:45 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       John Linville <linville@tuxdriver.com>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       Ingo Molnar <mingo@elte.hu>, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org,
       "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] Add dma_set_mask_weak() API
Message-ID: <20080501172045.35686f43@core>
In-Reply-To: <200805011640.17281.mb@bu3sch.de>
References: <200805011638.15910.mb@bu3sch.de>
	<200805011640.17281.mb@bu3sch.de>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 May 2008 16:40:16 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> This adds a new DMA subsystem API call for "weak" setting
> of the DMA mask

weak is an odd term - and we use weak for things like weak symbols so it
might be confusing. dma_request_mask() ?

Alan
