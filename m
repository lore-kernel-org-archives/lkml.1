Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZGXS04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZGXS04 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 14:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753835AbZGXS0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 14:26:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbZGXS0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 14:26:53 -0400
Date: Fri, 24 Jul 2009 11:12:31 -0700
From: Greg KH <gregkh@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Trevor Pace <tr212206@dal.ca>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Removed useless retval variables in usb-serial.c
Message-ID: <20090724181231.GB18094@suse.de>
References: <20090724124803.ltfbg57ooyoko0gs@my5.dal.ca>
 <20090724173422.GA10989@suse.de>
 <1248458542.3498.52.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248458542.3498.52.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 24, 2009 at 11:02:22AM -0700, Joe Perches wrote:
> On Fri, 2009-07-24 at 10:34 -0700, Greg KH wrote:
> > On Fri, Jul 24, 2009 at 12:48:03PM -0300, Trevor Pace wrote:
> > > Removed useless return value variables.
> > They seem useful to me, especially as it causes the code to fall out of
> > the function at the bottom, and not in the middle, which makes
> > maintaining the code easier to do over time, right?
> 
> If paint for the bike shed is still required,

Sorry, it's not, it's staying mauve and you better like it!

:)

thanks,

greg k-h
