Return-Path: <linux-kernel-owner+w=401wt.eu-S1753453AbYKFGjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753453AbYKFGjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 01:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYKFGjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 01:39:12 -0500
Received: from kroah.org ([198.145.64.141]:56137 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751024AbYKFGjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 01:39:11 -0500
Date: Wed, 5 Nov 2008 22:37:09 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "David S. Miller" <davem@davemloft.net>,
       "William L. Irwin" <wli@holomorphy.com>, sparclinux@vger.kernel.org
Subject: Re: sparc/staging compile error
Message-ID: <20081106063709.GB7728@kroah.com>
References: <20081106163626.2306ad75.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106163626.2306ad75.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 04:36:26PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's tree from Linus gets the following error from a sparc
> allmodconfig build:
> 
> ERROR: "___f_flush_cache_range" [drivers/staging/poch/poch.ko] undefined!

Odd, is flush_cache_range() not allowed on the sparc platform?

thanks,

greg k-h
