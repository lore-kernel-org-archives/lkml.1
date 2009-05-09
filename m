Return-Path: <linux-kernel-owner+w=401wt.eu-S1755820AbZEIFDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820AbZEIFDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 01:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754020AbZEIFDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 01:03:19 -0400
Received: from kroah.org ([198.145.64.141]:51222 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753819AbZEIFDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 01:03:18 -0400
Date: Fri, 8 May 2009 21:55:12 -0700
From: Greg KH <greg@kroah.com>
To: Xiaofan Chen <xiaofanc@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: usbutils 0.82 release
Message-ID: <20090509045512.GD14356@kroah.com>
References: <20090506222439.GB22327@kroah.com> <a276da400905080822u61f18893x3bd044037abee004@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a276da400905080822u61f18893x3bd044037abee004@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 11:22:43PM +0800, Xiaofan Chen wrote:
> On Thu, May 7, 2009 at 6:24 AM, Greg KH <greg@kroah.com> wrote:
> > Here's the 0.82 release of usbutils.
> >
> > Many bugs with autoconf were resolved to hopefully make it easier for
> > distros to find where the usb.ids file is dynamically.  Wireless USB
> > device support was added, as well as other bugfixes.  The full shortlog
> > is below.
> 
> By the way, the issue with "lsusb -t" has not been solved.

Yes, it's an interm fix before I get the time to hook into libudev...

If anyone wants to provide patches to fix this before then, I'll gladly
take them :)

thanks,

greg k-h
