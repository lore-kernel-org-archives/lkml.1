Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbYGPQdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbYGPQdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 12:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756966AbYGPQdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 12:33:07 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48375 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756427AbYGPQdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 12:33:07 -0400
Date: Wed, 16 Jul 2008 09:23:35 -0700
From: Greg KH <greg@kroah.com>
To: "Perez-Gonzalez, Inaky" <inaky.perez-gonzalez@intel.com>
Cc: David Vrabel <david.vrabel@csr.com>, linux-usb <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Dropping WUSB/UWB from my patch queue
Message-ID: <20080716162335.GA7448@kroah.com>
References: <20080630180009.GA30833@kroah.com> <4871E9F0.60608@csr.com> <20080715155313.GA3075@kroah.com> <487CE2E7.90505@csr.com> <20080716054911.GA9806@kroah.com> <487DC4FA.4050505@csr.com> <C72DEB015BA7724783363DE1AF6B0F9805393C24@orsmsx417.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C72DEB015BA7724783363DE1AF6B0F9805393C24@orsmsx417.amr.corp.intel.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2008 at 09:20:30AM -0700, Perez-Gonzalez, Inaky wrote:
> >From: David Vrabel [mailto:david.vrabel@csr.com]
> >
> >Postponed:
> >
> >* HWA radio controller driver
> >* Wire Adapter core (for HWAs and DWAs).
> >* HWA host controller
> >* WLP support
> >* i1480 firmware download driver.
> >* i1480 WLP driver.
> 
> If I got you a fix for the USB reset stuff, would you be able to merge
> these guys?

I don't see why not.

thanks,

greg k-h
