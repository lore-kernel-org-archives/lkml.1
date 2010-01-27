Return-Path: <linux-kernel-owner+w=401wt.eu-S1753641Ab0A0ANG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab0A0ANG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:13:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252Ab0A0ANB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:13:01 -0500
Received: from cantor.suse.de ([195.135.220.2]:60378 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab0A0ANA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:13:00 -0500
Date: Tue, 26 Jan 2010 16:11:13 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dmitry Torokhov <dtor@mail.ru>
Subject: Re: [61/98] Input: i8042 - remove identification strings from DMI
 tables
Message-ID: <20100127001113.GA32478@suse.de>
References: <20100126233928.894956940@mini.kroah.org>
 <alpine.LFD.2.00.1001261559240.17519@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001261559240.17519@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 26, 2010 at 04:00:16PM -0800, Linus Torvalds wrote:
> 
> 
> On Tue, 26 Jan 2010, Greg KH wrote:
> >
> > 2.6.32-stable review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > 
> > commit f909b1df0a068f30e252d8dc3e9d45ca25bf266f upstream.
> > 
> > The driver does not reference identification strings in DMI tables and
> > since these strings are no longer required by DMI core we can safely
> > remove them and save some memory.
> > 
> > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> 
> This seems to have lost your sign-off?

Argh, good catch, I've now added it.

thanks,

greg k-h
