Return-Path: <linux-kernel-owner+w=401wt.eu-S1759457AbYG1RKF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759457AbYG1RKF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:10:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759807AbYG1RJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:09:47 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:61218 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759761AbYG1RJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:09:46 -0400
Date: Mon, 28 Jul 2008 20:09:04 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 calgary: replace num_dma_pages() with
	iommu_num_pages()
Message-ID: <20080728170904.GA10532@il.ibm.com>
References: <1217248100-3019-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217248100-3019-1-git-send-email-joerg.roedel@amd.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 02:28:20PM +0200, Joerg Roedel wrote:
> This patch removes the num_dma_pages() function from Calgary IOMMU code and
> replaces it with the generic iommu_num_pages() function.
> 
> Cc: Muli Ben-Yehuda <muli@il.ibm.com>
> Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

Thanks Joerg,

Acked-by: Muli Ben-Yehuda <muli@il.ibm.com>

Cheers,
Muli
