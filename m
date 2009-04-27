Return-Path: <linux-kernel-owner+w=401wt.eu-S1761377AbZD0VGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761377AbZD0VGW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 17:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZD0VGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 17:06:10 -0400
Received: from kroah.org ([198.145.64.141]:41637 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757471AbZD0VGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 17:06:09 -0400
Date: Mon, 27 Apr 2009 14:00:59 -0700
From: Greg KH <greg@kroah.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Kay Sievers <kay.sievers@vrfy.org>, USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: usbutils 0.81 release
Message-ID: <20090427210059.GA12446@kroah.com>
References: <20090427193532.GA2948@kroah.com> <Pine.LNX.4.44L0.0904271645380.15670-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.0904271645380.15670-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 27, 2009 at 04:48:00PM -0400, Alan Stern wrote:
> On Mon, 27 Apr 2009, Greg KH wrote:
> 
> > Kay Sievers (11):
> >       rename configure.in -> configure.ac
> >       delete spec file
> 
> Why delete the spec file?  Don't you want to keep it for people who 
> would like to build an RPM?

Do people build rpms out of tarballs that aren't coming from their
distro anymore?  I didn't realise this, and can put it back, but it's
one more thing to forget to bump the version number on :(

thanks,

greg k-h
