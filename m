Return-Path: <linux-kernel-owner+w=401wt.eu-S1755846AbYKTO0y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbYKTO0y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 09:26:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756377AbYKTOZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 09:25:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755425AbYKTOZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 09:25:31 -0500
Subject: Re: [PATCH] intel-iommu: make init_dmars() static
From: David Woodhouse <dwmw2@infradead.org>
To: Mark McLoughlin <markmc@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>,
       iommu@lists.linux-foundation.org
In-Reply-To: <1227190873.3739.24.camel@blaa>
References: <1227190873.3739.24.camel@blaa>
Content-Type: text/plain
Date: Thu, 20 Nov 2008 14:25:25 +0000
Message-Id: <1227191125.4901.22.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-20 at 14:21 +0000, Mark McLoughlin wrote:
> init_dmars() is not used outside of drivers/pci/intel-iommu.c
> 
> Signed-off-by: Mark McLoughlin <markmc@redhat.com>

Applied; thank you.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

