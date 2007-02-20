Return-Path: <linux-kernel-owner+w=401wt.eu-S965569AbXBTABN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965569AbXBTABN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:01:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965573AbXBTABN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:01:13 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35979 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965569AbXBTABM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:01:12 -0500
Date: Tue, 20 Feb 2007 01:01:10 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: Linux 2.6.16.41
Message-ID: <20070220000110.GV13958@stusta.de>
References: <20070218011406.GT13958@stusta.de> <20070219234846.GA5201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070219234846.GA5201@kroah.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 19, 2007 at 03:48:46PM -0800, Greg KH wrote:
> On Sun, Feb 18, 2007 at 02:14:07AM +0100, Adrian Bunk wrote:
> > Herbert Xu (1):
> >       [NETFILTER]: Clear GSO bits for TCP reset packet
> 
> This patch causes the file it patched to not build at all.  Are you sure
> it was correct to add this?

It compiled for me in my test builds.

Please send the .config and the error message.

> thanks,
> 
> greg k-h

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

