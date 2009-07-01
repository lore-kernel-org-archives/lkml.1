Return-Path: <linux-kernel-owner+w=401wt.eu-S1755855AbZGASSC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855AbZGASSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 14:18:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZGASRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 14:17:53 -0400
Received: from kroah.org ([198.145.64.141]:38845 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752742AbZGASRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 14:17:52 -0400
Date: Wed, 1 Jul 2009 11:17:24 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: subrata@linux.vnet.ibm.com, linux-usb@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>, sachinp <sachinp@linux.vnet.ibm.com>,
       balbir <balbir@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch] buildfix ppc randconfig
Message-ID: <20090701181724.GA3623@kroah.com>
References: <200906190535.35138.david-b@pacbell.net>
 <1246454764.6978.60.camel@subratamodak.linux.ibm.com>
 <200907011106.24043.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907011106.24043.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 11:06:23AM -0700, David Brownell wrote:
> On Wednesday 01 July 2009, Subrata Modak wrote:
> > Greg/David,
> > 
> > Has this been checked in? I am not sure if i know this.
> 
> It seems not to be in Greg's "gregkh-02-usb.current"
> quilt queue.  If Greg's not got near-future cycles
> to get USB patches upstream, maybe this can merge
> sooner through the PPC tree.

I think it's in my "to-apply" queue, I've been stuck doing -stable
releases the past few days, so hopefully will have some cycles to get to
these now.

thanks,

greg k-h
