Return-Path: <linux-kernel-owner+w=401wt.eu-S1760667AbZD2UXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760667AbZD2UXm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:23:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757010AbZD2UXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:23:32 -0400
Received: from netrider.rowland.org ([192.131.102.5]:49150 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755722AbZD2UXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:23:31 -0400
Date: Wed, 29 Apr 2009 16:23:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: Benny Amorsen <benny+usenet@amorsen.dk>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: usbutils 0.81 release
In-Reply-To: <20090429174232.GA29026@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0904291612360.1234-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This thread is getting a bit ridiculous (especially with the annoying
GMANE redirections and challenges), and it's not an important issue, so
this will be my last word on the subject.

On Wed, 29 Apr 2009, Greg KH wrote:

> On Wed, Apr 29, 2009 at 11:51:12AM -0400, Alan Stern wrote:
> > 
> > 
> > 
> > On Wed, 29 Apr 2009, Benny Amorsen wrote:
> > 
> > > Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> > > writes:
> > > 
> > > > Sure they do.  If you've got an RPM-based system, and you want to
> > > > install a package version that's more recent than the one bundled in
> > > > your distribution (or if your distribution doesn't include the package
> > > > at all), then you'd want to build your own RPM.
> > > 
> > > In that case you grab the source package from the distribution, install
> > > it, bump the version number and add the tar file to the SOURCES
> > > directory. (And then you remove the patches which were upstreamed in the
> > > meantime).
> > 
> > You didn't read all that I wrote.  What if the package isn't included 
> > in the distribution at all?
> 
> What rpm based distro does not have usbutils?

As far as I know, all of them have it.

But that's not the point.  The point is this: The first quote above 
("Sure they do...") was in response to Greg's question

	Do people build rpms out of tarballs that aren't coming from
	their distro anymore?

Although it was asked in the context of a discussion about usbutils, it
is a general question.  (Notice that Benny's comment doesn't mention
usbutils either.)  Consequently I gave a general answer.

Maybe this sounds like sophistry... and maybe it is.  That's just the 
way my mind works -- very literally at times.

Alan Stern

