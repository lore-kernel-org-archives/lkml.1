Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZGAN5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZGAN5W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 09:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbZGAN5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 09:57:04 -0400
Received: from kroah.org ([198.145.64.141]:51930 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752704AbZGAN5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 09:57:02 -0400
Date: Wed, 1 Jul 2009 06:56:49 -0700
From: Greg KH <greg@kroah.com>
To: Arseniy Lartsev <ars3n@yandex.ru>
Cc: Oliver Neukum <oliver@neukum.org>, Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cdc-acm: work around some broken devices
Message-ID: <20090701135649.GA27932@kroah.com>
References: <Pine.LNX.4.44L0.0906301656440.5222-100000@iolanthe.rowland.org>
 <200907011525.00689.ars3n@yandex.ru>
 <200907011337.48901.oliver@neukum.org>
 <200907011627.31170.ars3n@yandex.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907011627.31170.ars3n@yandex.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 04:27:26PM +0400, Arseniy Lartsev wrote:
> On Wednesday 01 July 2009 15:37:48 Oliver Neukum wrote:
> > Yes, exactly. Please add greg@kroah.com into CC, add a Signed-off-by line
> > and resend.
> ok
> 
> Signed-off-by: Arseniy Lartsev <ars3n at yandex dot ru>

Real email address please, no "at" or "dot", it messes up our scripts.

And what does this patch do?  I need some text for the changelog.

thanks,

greg k-h
