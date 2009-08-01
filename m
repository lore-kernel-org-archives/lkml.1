Return-Path: <linux-kernel-owner+w=401wt.eu-S1751487AbZHAEk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751487AbZHAEk0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 00:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750753AbZHAEkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 00:40:25 -0400
Received: from kroah.org ([198.145.64.141]:40702 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbZHAEkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 00:40:25 -0400
Date: Fri, 31 Jul 2009 21:39:05 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: tty tree change for linux-next
Message-ID: <20090801043905.GA12779@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

I've now merged Alan's tty tree into my patch trees, and I'd like to ask
for linux-next to pick them up.

They are contained within the same directory as my other trees (staging,
usb, driver-core), and conviently named "tty.current" and "tty", and can
be found at:
	http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
As you can see by the nameing in the above directory, the usb and
staging trees changed names by virtue of putting the tty tree ahead of
them.  Your scripts might need adjusting for this.

If there are any problems with the trees, please let me know.

thanks,

greg k-h
