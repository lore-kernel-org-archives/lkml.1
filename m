Return-Path: <linux-kernel-owner+w=401wt.eu-S1752452AbZHMCyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbZHMCyv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 22:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZHMCyu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 22:54:50 -0400
Received: from kroah.org ([198.145.64.141]:36678 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbZHMCyu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 22:54:50 -0400
Date: Wed, 12 Aug 2009 19:53:09 -0700
From: Greg KH <greg@kroah.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jan Blunck <jblunck@suse.de>, gregkh@suse.de,
       Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based
 /dev
Message-ID: <20090813025309.GB21665@kroah.com>
References: <20090805171513.GA10443@kroah.com>
 <d82e647a0908121918t7cc681ctd7973714def48d27@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d82e647a0908121918t7cc681ctd7973714def48d27@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 10:18:55AM +0800, Ming Lei wrote:
> 2009/8/6 Greg KH <greg@kroah.com>:
> > Here's the devtmpfs patch again.  For .32 it's a simple and clean patch.
> 
> I also prefer devtmpfs.
> 
> Base on devtmpfs, we can remove polling for being ready of some
> asynchronous root device(usb storage, mmc, ....)
> easily before mounting rootfs.
> 
>       http://marc.info/?l=linux-kernel&m=124955163908015&w=2
>       http://marc.info/?l=linux-kernel&m=124955166508077&w=2

Yes, I like your patches, they are in my "to apply" queue, I wanted to
make sure the devtmpfs original patch was all ok first before applying.
I'll get to them later this week.

thanks,

greg k-h
