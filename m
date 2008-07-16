Return-Path: <linux-kernel-owner+w=401wt.eu-S1758555AbYGPHTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555AbYGPHTz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 03:19:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752013AbYGPHTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 03:19:45 -0400
Received: from verein.lst.de ([213.95.11.210]:45399 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751061AbYGPHTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 03:19:45 -0400
Date: Wed, 16 Jul 2008 09:19:22 +0200
From: Christoph Hellwig <hch@lst.de>
To: xfs-masters@oss.sgi.com, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: linux-next: Tree for June 24 (XFS x2)
Message-ID: <20080716071922.GA16777@lst.de>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au> <20080624171809.42bbdf68.randy.dunlap@oracle.com> <20080625003751.GP29319@disturbed> <20080627132317.GB23854@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080627132317.GB23854@lst.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 03:23:17PM +0200, Christoph Hellwig wrote:
> 
> The tree is still messed up.  This original [XFS] commit is still there,
> but also a revert of it.  but no patch with the actual changes again (?)
> 
> Also my patch to switch to the generic xattr code is attributed to
> Lachlan and appears twice in the commit list.  I think this whole git
> tree needs to be regenerated.

Could this please get fixed before the 2.6.27 pull?  The xfs.git tree
now has Linus' latest changes pulled but this still doesn't look
fixed up.
