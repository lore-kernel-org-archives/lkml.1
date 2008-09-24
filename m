Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbYIXDdp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbYIXDdp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:33:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYIXDdg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:33:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:36338 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbYIXDdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:33:35 -0400
Date: Tue, 23 Sep 2008 20:31:59 -0700
From: Greg KH <greg@kroah.com>
To: Franko Fang <huananhu@huawei.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       Lin.Lei@huawei.com, zhangqianchun@huawei.com
Subject: Re: [PATCH 10/4]linux-usb: To support more Huawei data card
	product IDs, fix kernel 2.6.26.5
Message-ID: <20080924033159.GA25368@kroah.com>
References: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com> <20080924023053.GA24846@kroah.com> <019701c91df2$08d1d430$f9100b0a@china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <019701c91df2$08d1d430$f9100b0a@china.huawei.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:02:52AM +0800, Franko Fang wrote:
> Dear Greg KH,
> 
>  I am sorry, but I can only get the newest version from
>  http://www.kernel.org/pub/linux/kernel/ is 2.6.26.5.
> 
>  Can you tell me the link to download 2.6.27-rc7 ?

It is a patch against 2.6.26 and is at:
	http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.27-rc7.bz2

You can get the latest pre-patch always from the main page of kernel.org
in the line:
	The latest prepatch for the stable Linux kernel tree is:

I suggest either using git to pull the latest version from Linus's git
tree, or use the tool, ketchup, to install the latest version at all
times.

Hope this helps,

greg k-h
