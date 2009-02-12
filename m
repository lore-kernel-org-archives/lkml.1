Return-Path: <linux-kernel-owner+w=401wt.eu-S1760707AbZBLV5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760707AbZBLV5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 16:57:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756773AbZBLV5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 16:57:46 -0500
Received: from kroah.org ([198.145.64.141]:53612 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754932AbZBLV5q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 16:57:46 -0500
Date: Thu, 12 Feb 2009 13:55:37 -0800
From: Greg KH <greg@kroah.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: checkpatch.pl --file gives wierd warning
Message-ID: <20090212215537.GA19528@kroah.com>
References: <20090212210532.GA5727@kroah.com> <20090212215040.GC6698@shadowen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212215040.GC6698@shadowen.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 09:50:40PM +0000, Andy Whitcroft wrote:
> On Thu, Feb 12, 2009 at 01:05:32PM -0800, Greg KH wrote:
> > Hi Andy,
> > 
> > With Linus's tree I get the following wierd warning when using the
> > --file option on checkpatch.pl:
> > 	$ ./scripts/checkpatch.pl --file drivers/staging/phison/phison.c
> > 	WARNING: patch prefix 'drivers' exists, appears to be a -p0 patch
> > 
> > I'm guessing that this isn't intentional :)
> > 
> > Any ideas?
> 
> heh yeah, thats fixed in my tree.  I should check the last couple of
> days testing and push those.

Ok, thanks, just wanted to make sure you knew about it.

greg k-h
