Return-Path: <linux-kernel-owner+w=401wt.eu-S1759658AbZD2RQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759658AbZD2RQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757923AbZD2RQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:16:36 -0400
Received: from blaine.gmane.org ([80.91.229.8]:58199 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751050AbZD2RQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:16:36 -0400
Date: Wed, 29 Apr 2009 11:51:12 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benny Amorsen <benny+usenet@amorsen.dk>
cc: Alan Stern 
	<public-stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@hugh.gmane.org>,
       Greg KH <public-greg-U8xfFu+wG4EAvxtiuMwx3w@hugh.gmane.org>,
       Kay Sievers <public-kay.sievers-tD+1rO4QERM@hugh.gmane.org>,
       USB list <public-linux-usb-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
       Kernel development list 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
Subject: Re: usbutils 0.81 release
In-Reply-To: <m3ab5z35f1.fsf@ursa.amorsen.dk>
Message-ID: <Pine.LNX.4.44L0.0904291150200.24643-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TMDA-Confirmed: Wed, 29 Apr 2009 18:27:57 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Wed, 29 Apr 2009, Benny Amorsen wrote:

> Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>
> writes:
> 
> > Sure they do.  If you've got an RPM-based system, and you want to
> > install a package version that's more recent than the one bundled in
> > your distribution (or if your distribution doesn't include the package
> > at all), then you'd want to build your own RPM.
> 
> In that case you grab the source package from the distribution, install
> it, bump the version number and add the tar file to the SOURCES
> directory. (And then you remove the patches which were upstreamed in the
> meantime).

You didn't read all that I wrote.  What if the package isn't included 
in the distribution at all?

Alan Stern



