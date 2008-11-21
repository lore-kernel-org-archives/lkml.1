Return-Path: <linux-kernel-owner+w=401wt.eu-S1756742AbYKUXTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742AbYKUXTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 18:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752818AbYKUXS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 18:18:58 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40105
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbYKUXS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 18:18:57 -0500
Date: Fri, 21 Nov 2008 15:18:57 -0800 (PST)
Message-Id: <20081121.151857.104010187.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: Re: [PATCH 01/10] x86: add Kconfig entry for DMA-API debugging
From: David Miller <davem@davemloft.net>
In-Reply-To: <1227284770-19215-2-git-send-email-joerg.roedel@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
	<1227284770-19215-2-git-send-email-joerg.roedel@amd.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Fri, 21 Nov 2008 17:26:01 +0100

> Impact: adds a new Kconfig option
> 
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

This definitely should be generic code, rather than something
tucked away in x86 platform code.
