Return-Path: <linux-kernel-owner+w=401wt.eu-S933018AbXHVSpj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933018AbXHVSpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:45:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764116AbXHVSp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:45:28 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:39610 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765034AbXHVSp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:45:26 -0400
From: akepner@sgi.com
Date: Wed, 22 Aug 2007 11:44:24 -0700
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, rdreier@cisco.com,
       linux-ia64 <linux-ia64@vger.kernel.org>
Subject: Re: [PATCH 2/3] dma: override "dma_flags_set_dmaflush" for sn-ia64
Message-ID: <20070822184424.GT5592@sgi.com>
References: <20070818002746.GU1813@sgi.com> <200708220951.05101.jbarnes@virtuousgeek.org> <1187802272.3410.58.camel@localhost.localdomain> <200708221017.11805.jbarnes@virtuousgeek.org> <1187806384.3410.70.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187806384.3410.70.camel@localhost.localdomain>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 01:13:04PM -0500, James Bottomley wrote:
> ......
> OK ... I think this is definitely a PCI specific API ... and probably a
> generic one for requesting order flushes in devices that have negotiated
> relaxed ordering.  Do you want to start a new thread on linux-pci and cc
> me?
> 

I'll do this.

-- 
Arthur

