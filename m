Return-Path: <linux-kernel-owner+w=401wt.eu-S1755577AbYLJHGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577AbYLJHGS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 02:06:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754372AbYLJHGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 02:06:04 -0500
Received: from kroah.org ([198.145.64.141]:38507 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754246AbYLJHGB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 02:06:01 -0500
Date: Tue, 9 Dec 2008 21:56:51 -0800
From: Greg KH <greg@kroah.com>
To: =?iso-8859-1?Q?J=FCri?= Reitel <juri.reitel@liewenthal.ee>
Cc: linux-kernel@vger.kernel.org
Subject: Re: USB serial gadget documentation and gserial.inf
Message-ID: <20081210055651.GA30463@kroah.com>
References: <4937933E.80207@liewenthal.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4937933E.80207@liewenthal.ee>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 10:22:22AM +0200, Jüri Reitel wrote:
> Improve linux documentation and add better gserial.inf file, now users will 
> not have to find the usbser.sys by themselves
>
> Signed-off-by: Kristjan Räts <kristjan.rats@liewenthal.ee>
> Signed-off-by: Jüri Reitel <juri.reitel@liewenthal.ee>

Care to send this to the usb gadget maintainer for review and the
linux-usb mailing list?  Also, I think your patch is a bit corrupted :(

thanks,

greg k-h
