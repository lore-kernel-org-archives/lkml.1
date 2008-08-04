Return-Path: <linux-kernel-owner+w=401wt.eu-S1757159AbYHDQLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757159AbYHDQLZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 12:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHDQLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 12:11:16 -0400
Received: from mtagate3.de.ibm.com ([195.212.29.152]:29113 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751AbYHDQLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 12:11:16 -0400
Date: Mon, 4 Aug 2008 19:09:41 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, rth@twiddle.net, paulus@samba.org,
       benh@kernel.crashing.org, davem@davemloft.net,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/10] x86: convert Calgary IOMMU driver to generic
	iommu_num_pages function
Message-ID: <20080804160941.GA7026@il.ibm.com>
References: <1217865890-3593-1-git-send-email-joerg.roedel@amd.com> <1217865890-3593-8-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217865890-3593-8-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2008 at 06:04:47PM +0200, Joerg Roedel wrote:

> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Acked-by: Muli Ben-Yehdua <muli@il.ibm.com>

Cheers,
Muli
