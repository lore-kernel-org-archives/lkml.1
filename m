Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZLWXkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZLWXkF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 18:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756822AbZLWXjt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 18:39:49 -0500
Received: from kroah.org ([198.145.64.141]:40180 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755929AbZLWXjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 18:39:44 -0500
Date: Wed, 23 Dec 2009 15:38:56 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stefani Seibold <stefani@seibold.net>
Subject: Re: linux-next: manual merge of the usb tree with Linus' tree
Message-ID: <20091223233856.GA19893@kroah.com>
References: <20091224093036.2ba1ecf5.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091224093036.2ba1ecf5.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 24, 2009 at 09:30:36AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/serial/generic.c between commit
> 119eecc831a42bd090543568932e440c6831f1bb ("Fix usb_serial_probe() problem
> introduced by the recent kfifo changes") from Linus' tree and commit
> 40b2ba0dfb62bed0f7cc6f699053d18ca4553e91 ("USB: serial: mct_usb232: add
> drain on close") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix for a while.  The result
> needs checking.

Thanks, I fixed this up already in my tree and will resync in a few
hours.

greg k-h
