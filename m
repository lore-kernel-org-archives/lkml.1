Return-Path: <linux-kernel-owner+w=401wt.eu-S1752210AbZHRXRc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210AbZHRXRc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:17:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752160AbZHRXRb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:17:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbZHRXRa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:17:30 -0400
Date: Tue, 18 Aug 2009 16:16:04 -0700
From: Greg KH <gregkh@suse.de>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.31-rc5 regression: Oops when USB Serial disconnected while
 in use
Message-ID: <20090818231604.GA27102@suse.de>
References: <20090808194733.38406075@neptune.home>
 <Pine.LNX.4.44L0.0908101114320.3208-100000@iolanthe.rowland.org>
 <20090810154402.GA7701@kroah.com>
 <20090810191822.26370810@neptune.home>
 <20090810181306.GA24989@kroah.com>
 <20090810203501.4d57aa5b@neptune.home>
 <20090810205115.6871239d@neptune.home>
 <20090810192954.GA11651@suse.de>
 <20090818190016.73ce53de@neptune.home>
 <20090818223648.GA25659@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090818223648.GA25659@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 18, 2009 at 03:36:48PM -0700, Greg KH wrote:
> On Tue, Aug 18, 2009 at 07:00:16PM +0200, Bruno Prémont wrote:
> > Hi Greg,
> > 
> > Were you able to reproduce this with a FTDI usbserial device?
> 
> No, I can't find one in my box.  I'll go dig in the attic next to try to
> find on, I knew I had one before...

Nope, all I found was mcd_u232 and pl2303 devices, no ftdi ones :(

Anyone have a brand name, or a link to one online that I can buy so that
I can get one for testing?

thanks,

greg k-h
