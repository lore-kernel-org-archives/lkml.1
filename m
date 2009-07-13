Return-Path: <linux-kernel-owner+w=401wt.eu-S1757519AbZGMVf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519AbZGMVf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756937AbZGMVf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:35:28 -0400
Received: from kroah.org ([198.145.64.141]:48172 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752741AbZGMVf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:35:27 -0400
Date: Mon, 13 Jul 2009 14:27:27 -0700
From: Greg KH <greg@kroah.com>
To: David Brownell <david-b@pacbell.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: driver-core tree build warning
Message-ID: <20090713212727.GA3813@kroah.com>
References: <20090713172646.55b9acee.sfr@canb.auug.org.au>
 <20090713175106.d2efbd60.sfr@canb.auug.org.au>
 <20090713171802.GB22728@kroah.com>
 <200907131423.59963.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907131423.59963.david-b@pacbell.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 02:23:59PM -0700, David Brownell wrote:
> On Monday 13 July 2009, Greg KH wrote:
> > David, care to send patches fixing these warnings?
> 
> Here's a single patch:

Thanks, I'll merge this with the original one.

greg k-h
