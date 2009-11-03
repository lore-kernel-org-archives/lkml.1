Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZKCD62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZKCD62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 22:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757902AbZKCD6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 22:58:16 -0500
Received: from kroah.org ([198.145.64.141]:46083 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757883AbZKCD6P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 22:58:15 -0500
Date: Mon, 2 Nov 2009 19:55:37 -0800
From: Greg KH <greg@kroah.com>
To: Alan Jenkins <sourcejedi.lkml@googlemail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
       Carmelo Amoroso <carmelo73@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: Fast LKM symbol resolution
Message-ID: <20091103035537.GB19515@kroah.com>
References: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520911020852q49c55695rb05d87090fa9ad33@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 04:52:47PM +0000, Alan Jenkins wrote:
> Here's my latest code using binary search for symbol resolution.  This
> version has benefited from a little more testing (heh), in particular
> running on a simulated ARM system.
> 
>     web: <http://github.com/sourcejedi/linux-2.6/commits/module-V2-beta1>
> 
>     git clone git://github.com/sourcejedi/linux-2.6.git module-V2-beta1

Care to post actual patches?

thanks,

greg k-h
