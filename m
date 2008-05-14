Return-Path: <linux-kernel-owner+w=401wt.eu-S1760263AbYENG6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760263AbYENG6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753420AbYENG63
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:58:29 -0400
Received: from mtagate6.de.ibm.com ([195.212.29.155]:14944 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967AbYENG62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:58:28 -0400
Date: Wed, 14 May 2008 08:49:24 +0300
From: Muli Ben-Yehuda <muli@il.ibm.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       alexisb@us.ibm.com
Subject: Re: [PATCH 0/2] x86: per-device dma_mapping_ops
Message-ID: <20080514054924.GD6682@il.ibm.com>
References: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210658692-960-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2008 at 03:04:50PM +0900, FUJITA Tomonori wrote:

> This patchset adds per-device dma_mapping_ops support for
> CONFIG_X86_64 like POWER architecture does. This change enables us
> to cleanly fix the Calgary IOMMU issue that some devices are not
> behind the IOMMU [1]. It also would be helpful to handle KVM PCI
> passthrough.

Awesome! Much needed, thank you for doing this.

Cheers,
Muli


