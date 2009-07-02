Return-Path: <linux-kernel-owner+w=401wt.eu-S1753456AbZGBSqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456AbZGBSqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 14:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZGBSpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 14:45:44 -0400
Received: from kroah.org ([198.145.64.141]:38300 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbZGBSpn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 14:45:43 -0400
Date: Thu, 2 Jul 2009 11:31:49 -0700
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       Linux-Kernel List <linux-kernel@vger.kernel.org>
Subject: Re: good example of a tty driver
Message-ID: <20090702183149.GA11720@kroah.com>
References: <D77CBB49-A340-4282-9ACF-2172D1BB9E43@kernel.crashing.org>
 <20090702192744.029620ae@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090702192744.029620ae@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 07:27:44PM +0100, Alan Cox wrote:
> On Thu, 2 Jul 2009 11:48:09 -0500
> Kumar Gala <galak@kernel.crashing.org> wrote:
> 
> > Alan,
> > 
> > Can you point me at any good drivers to use as an example of using the  
> > tty layer.  I'm trying to get an out of tree driver brought up to date  
> > for the Avocent ESP-16 MI Serial Hubs (serial over ethernet):
> 
> Its very much in flux with the drivers getting kref support, helper
> functions and the like in the current releases.
> 
> > 
> > http://www.connectivity.avocent.com/products/network-based/esp_16.asp
> > 
> > Thankfully the have a GPL driver but it was last updated against 2.6.23:
> > 
> > http://www.connectivity.avocent.com/drivers/esp_serial_hubs/dd64e069.asp
> > 
> > However I've never worked on any tty drivers so its a bit black magic  
> > at this point.  I was hoping that an example would at least get me  
> > able to bring the driver up to a point that we can get it into the  
> > staging tree.
> 
> I would make it build, chuck it in the staging tree and go from there

That sounds good to me as well.  Kumar, feel free to send me a patch :)

thanks,

greg k-h
