Return-Path: <linux-kernel-owner+w=401wt.eu-S1760992AbXGJAZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760992AbXGJAZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:25:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759362AbXGJAZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:25:14 -0400
Received: from canuck.infradead.org ([209.217.80.40]:35503 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757310AbXGJAZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:25:13 -0400
Date: Mon, 9 Jul 2007 17:09:18 -0700
From: Greg KH <greg@kroah.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] leds: Convert from struct class_device to struct device
Message-ID: <20070710000918.GA4954@kroah.com>
References: <1183981213.5757.33.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183981213.5757.33.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 12:40:13PM +0100, Richard Purdie wrote:
> Convert the LEDs class from struct class_device to struct device
> since class_device is scheduled for removal.
> 
> Signed-off-by: Richard Purdie <rpurdie@rpsys.net>
> 
> [I've applied this patch to the LEDs for-mm branch for testing but will
> work in any feedback] 

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
