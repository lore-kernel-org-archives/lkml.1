Return-Path: <linux-kernel-owner+w=401wt.eu-S1755413AbYH3GJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413AbYH3GJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 02:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751356AbYH3GJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 02:09:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37512 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYH3GJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 02:09:31 -0400
Date: Fri, 29 Aug 2008 23:09:20 -0700
From: Greg KH <greg@kroah.com>
To: Marcel Janssen <marcel.janssen@admesy.nl>
Cc: David Brownell <david-b@pacbell.net>,
       Stefan Kopp <stefan_kopp@agilent.com>,
       Felipe Balbi <me@felipebalbi.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Fwd: Re: [PATCH] USB: add USB test and measurement class driver
Message-ID: <20080830060920.GB17130@kroah.com>
References: <200808272342.38208.korgull@home.nl> <200808282022.54379.korgull@home.nl> <20080828203557.GB20537@kroah.com> <200808281537.50952.david-b@pacbell.net> <48B793E1.4000504@admesy.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48B793E1.4000504@admesy.nl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2008 at 08:14:57AM +0200, Marcel Janssen wrote:
> My basic concern was like the stress test, but also devices that take a 
> long time to perform measurements (long averaging/integrating) and have no 
> bus activity during that time. On the other hand I worry about the 
> variation in measurement results if a device keeps going in low power mode 
> all the time.

Do you know of any reasonably cheap USB TMC devices out there that I
could buy to help test this driver here?  I looked at the device that
your company makes, but I don't think it falls into the "cheap" category
:)

thanks,

greg k-h
