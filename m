Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZICQHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZICQHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 12:07:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754475AbZICQHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 12:07:18 -0400
Received: from kroah.org ([198.145.64.141]:46041 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568AbZICQHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 12:07:17 -0400
Date: Thu, 3 Sep 2009 09:05:36 -0700
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-usb@vger.kernel.org
Subject: Re: [2.6.31-rc8] Problem with detect USB devices
Message-ID: <20090903160536.GA24050@kroah.com>
References: <8db1092f0909020629v5aab79d8lbfcc8c214622787c@mail.gmail.com>
 <200909021542.11767.oliver@neukum.org>
 <8db1092f0909020715g3e6f9815w96efc801cc18e3bc@mail.gmail.com>
 <200909030907.02321.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909030907.02321.oliver@neukum.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 09:07:01AM +0200, Oliver Neukum wrote:
> Am Mittwoch, 2. September 2009 16:15:28 schrieb Maciej Rutecki:
> > KERNEL[1251900287.925994] remove
> > /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0/host4 (scsi)
> > KERNEL[1251900287.926058] remove
> > /devices/pci0000:00/0000:00:1d.7/usb1/1-1/1-1:1.0 (usb)
> 
> You are definitely seeing the correct kernel events.
> So it must be an indirect problem.
> 
> Greg, any changes in sysfs between rc7 and rc8?

No, not that I sent in.

thanks,

greg k-h
