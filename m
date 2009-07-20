Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZGTQaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZGTQaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 12:30:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZGTQaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 12:30:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36237 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZGTQaD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 12:30:03 -0400
Date: Mon, 20 Jul 2009 09:28:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       virtualization@lists.osdl.org
Cc: Hank Janssen <hjanssen@microsoft.com>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Sam Ramji <sramji@microsoft.com>, shemminger@linux-foundation.org
Subject: Re: [patch 00/54] [Announce] Microsoft Hyper-V drivers for Linux
Message-ID: <20090720162810.GA22102@kroah.com>
References: <20090720160025.GA20249@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090720160025.GA20249@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 09:00:25AM -0700, Greg Kroah-Hartman wrote:
> 
> Hi all,
> 
> I'm happy to announce, that after many months of discussions, Microsoft
> has released their Hyper-V Linux drivers under the GPLv2.  Following
> this message, will be the patches that add the drivers to the
> drivers/staging/ tree, and a whole bunch of cleanups.

Hm, for some reason my scripts to send patches out caused them to get
eaten by the very good lkml filters.  (note, it was my fault, not
lkml's).

So instead of trying to send them again, and spaming everyone who
already got them, you can find them in my staging tree at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/

If anyone wants me to post any of the individual 54 patches to them,
please let me know.

thanks,

greg k-h
