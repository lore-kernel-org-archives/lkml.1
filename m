Return-Path: <linux-kernel-owner+w=401wt.eu-S1762187AbYHEBfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187AbYHEBfp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 21:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754680AbYHEBaa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 21:30:30 -0400
Received: from gate.crashing.org ([63.228.1.57]:57957 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280AbYHEBa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 21:30:28 -0400
Subject: Re: [PATCH 10/10] sparc64: use iommu_num_pages function in IOMMU
	code
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: David Miller <davem@davemloft.net>
Cc: joerg.roedel@amd.com, akpm@linux-foundation.org, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net, paulus@samba.org,
       fujita.tomonori@lab.ntt.co.jp, muli@il.ibm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080804.142834.171476315.davem@davemloft.net>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com>
	 <1217865890-3593-11-git-send-email-joerg.roedel@amd.com>
	 <20080804.142834.171476315.davem@davemloft.net>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 11:09:13 +1000
Message-Id: <1217898553.24157.126.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-04 at 14:28 -0700, David Miller wrote:
> From: Joerg Roedel <joerg.roedel@amd.com>
> Date: Mon, 4 Aug 2008 18:04:50 +0200
> 
> > Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
> 
> So we rename, then convert everything back.
> 
> This seems like a lot of commit masterbation for what is
> clearly one single change.

Yup, I wouldn't mind a single patch doing the whole thing at once.

Ben.


