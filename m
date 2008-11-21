Return-Path: <linux-kernel-owner+w=401wt.eu-S1757567AbYKURYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757567AbYKURYw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 12:24:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754266AbYKURYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 12:24:40 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42116 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107AbYKURYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 12:24:40 -0500
Subject: Re: [PATCH 0/10] DMA-API debugging facility
From: David Woodhouse <dwmw2@infradead.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, netdev@vger.kernel.org,
       iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20081121172046.GF1386@amd.com>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com>
	 <1227286492.4901.208.camel@macbook.infradead.org>
	 <20081121165722.GD1386@amd.com>
	 <1227287215.4901.213.camel@macbook.infradead.org>
	 <20081121171802.GK733@elte.hu>  <20081121172046.GF1386@amd.com>
Content-Type: text/plain
Date: Fri, 21 Nov 2008 17:24:29 +0000
Message-Id: <1227288269.4901.222.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-11-21 at 18:20 +0100, Joerg Roedel wrote:
> Ok, I will move the generic bits to lib/ and include/linux and let
> architectures decide if they want to use it.

Once you've done that, I'll try to hook it up on PowerPC to make sure it
works there.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

