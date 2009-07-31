Return-Path: <linux-kernel-owner+w=401wt.eu-S1751769AbZGaOVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751769AbZGaOVa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 10:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbZGaOVa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 10:21:30 -0400
Received: from kroah.org ([198.145.64.141]:55468 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbZGaOV3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 10:21:29 -0400
Date: Fri, 31 Jul 2009 07:16:00 -0700
From: Greg KH <greg@kroah.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: RTL8192SE support status
Message-ID: <20090731141600.GA28088@kroah.com>
References: <200907311431.17043.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200907311431.17043.bzolnier@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 31, 2009 at 02:31:16PM +0200, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> I've been getting some private mail regarding the status of RTL8192SE
> wireless chipset support (the chipset is used in some newer netbooks,
> i.e. Medion Akoya E1312) so the current situation is:
> 
> * I'm not working on it and I don't know if/when the driver is coming.
> 
> * Realtek has been queried about the issue two weeks ago but we haven't
>   heard anything back yet.
> 
> * rtl8192su driver present in staging area of the kernel is for RTL8192SU
>   (USB version of the chipset) and never contained working/complete code
>   for RTL8192SE (PCI-E version of the chipset) so there is no point in
>   attempts of reverting some patches in hope that it will make the things
>   magically work (it won't, please save your time).

Thanks for letting us know, this helps out a lot.

greg k-h
