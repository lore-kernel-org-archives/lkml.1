Return-Path: <linux-kernel-owner+w=401wt.eu-S1752284AbZGTD5i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284AbZGTD5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jul 2009 23:57:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZGTD5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Jul 2009 23:57:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:53046 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751328AbZGTD5f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jul 2009 23:57:35 -0400
Date: Sun, 19 Jul 2009 20:48:59 -0700
From: Greg KH <gregkh@suse.de>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 0/8] 2.6.27.27-stable review
Message-ID: <20090720034859.GA10773@suse.de>
References: <20090717203935.GA5641@kroah.com>
 <200907180329.34323.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907180329.34323.arekm@maven.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 18, 2009 at 03:29:34AM +0200, Arkadiusz Miskiewicz wrote:
> On Friday 17 of July 2009, Greg KH wrote:
> > This is the start of the stable review cycle for the 2.6.27.27 release.
> 
> Broken md patch that got applied in 2.6.27.26 should be reverted, see:
> 
> http://lkml.org/lkml/2009/7/3/294

Ah, thanks for reminding me, I've now reverted this.

thanks again,

greg k-h
