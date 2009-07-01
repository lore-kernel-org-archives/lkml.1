Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZGASew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZGASew (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754159AbZGASen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:34:43 -0400
Received: from 8bytes.org ([88.198.83.132]:33230 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZGASem (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:34:42 -0400
Date: Wed, 1 Jul 2009 20:34:44 +0200
From: Joerg Roedel <joro@8bytes.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, benh@kernel.crashing.org,
       netdev@vger.kernel.org, iommu@lists.linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support DMA-API debugging facility on PowerPC
Message-ID: <20090701183444.GI4182@8bytes.org>
References: <1227284770-19215-1-git-send-email-joerg.roedel@amd.com> <1227286492.4901.208.camel@macbook.infradead.org> <20081121165722.GD1386@amd.com> <1227287215.4901.213.camel@macbook.infradead.org> <20081121171802.GK733@elte.hu> <20081121172046.GF1386@amd.com> <1227288269.4901.222.camel@macbook.infradead.org> <20081121172722.GG1386@amd.com> <1233873842.8135.6.camel@macbook.infradead.org> <1246454380.3681.1634.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246454380.3681.1634.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 02:19:40PM +0100, David Woodhouse wrote:
> 
> Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
> Tested-by: Johannes Berg <johannes@sipsolutions.net>

Acked-by: Joerg Roedel <joerg.roedel@amd.com>

Great stuff. You may also consider registering the powerpc io buses to
dma-api debug. Then you get the driver memory leak functionality too.

Joerg

