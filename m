Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZGUQyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZGUQyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 12:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbZGUQyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 12:54:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41594 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbZGUQyu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 12:54:50 -0400
Date: Tue, 21 Jul 2009 09:51:07 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: virtualization@lists.linux-foundation.org, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       Andi Kleen <andi@firstfloor.org>, Dave Jones <davej@redhat.com>
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090721165107.GF14746@kroah.com>
References: <20090720160025.GA20249@kroah.com>
 <871vob4047.fsf@basil.nowhere.org>
 <20090720195754.GB30483@suse.de>
 <200907211407.40229.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907211407.40229.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 21, 2009 at 02:07:40PM +0200, Arnd Bergmann wrote:
> On Monday 20 July 2009, Greg KH wrote:
> > Anyway, I agree, for a "proper" review, I will show the final, cleaned
> > up version, like normal.  But we aren't there just yet, that is why this
> > code is going to live in the staging tree for a while.  Give us some
> > time to get it fixed up.
> 
> I would find it helpful to have them in a git tree (or a branch) that
> I can pull, so I can look at both the original code and the cleaned up
> state.
> 
> Any reason why the patches are not yet in your staging.git?

staging.git is for sending patches to Linus only.  Look in the
MAINTAINERS file for a location of my tree of patches for staging.

If you like git, I'd recommend just using the linux-next tree, as that
always has the latest staging patches in it.

thanks,

greg k-h
