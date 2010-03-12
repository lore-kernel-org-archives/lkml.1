Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933138Ab0CLNab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 08:30:31 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:40627 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab0CLNa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 08:30:29 -0500
Date: Fri, 12 Mar 2010 14:30:22 +0100
From: Alexander Schmidt <alexs@linux.vnet.ibm.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, alsa-devel@alsa-project.org,
       broonie@opensource.wolfsonmicro.com, linux-ide@vger.kernel.org,
       James.Bottomley@suse.de, linux-i2c@vger.kernel.org,
       sparclinux@vger.kernel.org, jeremy.kerr@canonical.com,
       sfr@canb.auug.org.au, linux-scsi@vger.kernel.org, jgarzik@pobox.com,
       microblaze-uclinux@itee.uq.edu.au, devicetree-discuss@lists.ozlabs.org,
       Christoph Raisch <raisch@de.ibm.com>, ben-linux@fluff.org,
       monstr@monstr.eu, linuxppc-dev@ozlabs.org, netdev@vger.kernel.org,
       gregkh@suse.de, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       dwmw2@infradead.org, davem@davemloft.net
Subject: Re: [PATCH 25/37] drivers/infiniband: use .dev.of_node instead of
 .node in struct of_device
Message-ID: <20100312143022.18b954a5@alex-laptop>
In-Reply-To: <adavdd2d41q.fsf@roland-alpha.cisco.com>
References: <20100311174830.4824.19820.stgit@angua>
	<20100311180605.4824.3613.stgit@angua>
	<adavdd2d41q.fsf@roland-alpha.cisco.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Mar 2010 11:57:53 -0800
Roland Dreier <rdreier@cisco.com> wrote:

> Seems fine... adding EHCA guys just to make sure.
> 
>  > .node is being removed
>  > 
>  > Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Alexander Schmidt <alexs@linux.vnet.ibm.com>
