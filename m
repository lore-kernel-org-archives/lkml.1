Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbYHDV2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbYHDV2p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 17:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757672AbYHDV2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 17:28:38 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33677
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1757864AbYHDV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 17:28:37 -0400
Date: Mon, 04 Aug 2008 14:28:34 -0700 (PDT)
Message-Id: <20080804.142834.171476315.davem@davemloft.net>
To: joerg.roedel@amd.com
Cc: akpm@linux-foundation.org, mingo@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, rth@twiddle.net, paulus@samba.org,
       benh@kernel.crashing.org, fujita.tomonori@lab.ntt.co.jp,
       muli@il.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] sparc64: use iommu_num_pages function in IOMMU
 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1217865890-3593-11-git-send-email-joerg.roedel@amd.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
	<1217865890-3593-11-git-send-email-joerg.roedel@amd.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <joerg.roedel@amd.com>
Date: Mon, 4 Aug 2008 18:04:50 +0200

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

So we rename, then convert everything back.

This seems like a lot of commit masterbation for what is
clearly one single change.
