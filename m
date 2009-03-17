Return-Path: <linux-kernel-owner+w=401wt.eu-S1760061AbZCQQRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbZCQQRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 12:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757189AbZCQQRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 12:17:12 -0400
Received: from kroah.org ([198.145.64.141]:50261 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756703AbZCQQRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 12:17:10 -0400
Date: Tue, 17 Mar 2009 09:13:41 -0700
From: Greg KH <greg@kroah.com>
To: Rory Filer <rfiler@SierraWireless.com>
Cc: Ralf Nyren <ralf@nyren.net>, Stephen Clark <sclark46@earthlink.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Kevin Lloyd <klloyd@SierraWireless.com>
Subject: Re: Sierra Wireless (MC8780) HSDPA speed issue
Message-ID: <20090317161341.GA27956@kroah.com>
References: <alpine.DEB.1.10.0903142021580.5797@fujje.iml.umu.se> <20090314203256.GA7487@kroah.com> <49BC5A90.7070004@earthlink.net> <alpine.DEB.1.10.0903152040030.5825@fujje.iml.umu.se> <8F90F944E50427428C60E12A34A309D21C401BAA8D@carmd-exchmb01.sierrawireless.local> <20090316043359.GA24632@kroah.com> <alpine.DEB.1.10.0903161324440.32709@fujje.iml.umu.se> <8F90F944E50427428C60E12A34A309D21C401BAB03@carmd-exchmb01.sierrawireless.local> <alpine.DEB.1.10.0903171642030.10762@fujje.iml.umu.se> <8F90F944E50427428C60E12A34A309D21C40221D59@carmd-exchmb01.sierrawireless.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8F90F944E50427428C60E12A34A309D21C40221D59@carmd-exchmb01.sierrawireless.local>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 17, 2009 at 09:04:22AM -0700, Rory Filer wrote:
> Hi Ralf, 
> 
> I wonder whether you could do a little experiment for me. Issue the following AT command to both ports you've identified:
> 
> ATI
> 
> And note which of the AT ports provides the most information. They will both respond, but one will be more verbose than the others. 
> 
> Another thing of interest is to record how many files appear in response to the following command:
> 
> ls /dev/ttyU*
> 
> when the modem is running, of course. 
> 
> Question - at what point should we stop including linux-kernel in this thread, if at all?

If it's related to the driver like this, you should not stop including
linux-kernel.

By copying the list, it provides a well archived history of the problem
so that anyone who runs across it in the future can easily find it by
searching the web.

thanks,

greg k-h
