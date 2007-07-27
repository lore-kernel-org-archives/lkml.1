Return-Path: <linux-kernel-owner+w=401wt.eu-S1763513AbXG0AzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763513AbXG0AzS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756901AbXG0AzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:55:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48610
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbXG0AzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:55:04 -0400
Date: Thu, 26 Jul 2007 17:55:03 -0700 (PDT)
Message-Id: <20070726.175503.32096994.davem@davemloft.net>
To: benh@kernel.crashing.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] remove flush_tlb_pgtables
From: David Miller <davem@davemloft.net>
In-Reply-To: <1185497047.5495.159.camel@localhost.localdomain>
References: <1185497047.5495.159.camel@localhost.localdomain>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Fri, 27 Jul 2007 10:44:06 +1000

> After my frv patch, nobody uses flush_tlb_pgtables anymore, this patch
> removes all remaining traces of it from all archs.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Acked-by: David S. Miller <davem@davemloft.net>
