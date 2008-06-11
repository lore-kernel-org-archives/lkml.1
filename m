Return-Path: <linux-kernel-owner+w=401wt.eu-S1762482AbYFKTBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762482AbYFKTBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 15:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbYFKTAo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 15:00:44 -0400
Received: from casper.infradead.org ([85.118.1.10]:52416 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbYFKTAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 15:00:43 -0400
Date: Wed, 11 Jun 2008 11:55:27 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 11
Message-ID: <20080611185527.GB5516@kroah.com>
References: <20080611193840.08a35b14.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080611193840.08a35b14.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2008 at 07:38:40PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since next-20080610:
> 
> Dropped trees (temporary): ldp (it is unfetchable - probably something to
> do with the new Staging tree), block (it just has too many conflicts and
> breaks the powerpc build).

Yes, I've dropped "ldp" from my 'gregkh' set of patches/trees, they
should be pulled in from the -staging tree, which would be great if you
could add to the end of the -next tree.

I've also removed some of the larger patches in the driver-core tree
that were causing you merge/build errors, they should be all resolved
now.

thanks,

greg k-h
