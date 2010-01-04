Return-Path: <linux-kernel-owner+w=401wt.eu-S1753457Ab0ADPdm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab0ADPdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 10:33:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753409Ab0ADPdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 10:33:38 -0500
Received: from kroah.org ([198.145.64.141]:43063 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0ADPdi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:33:38 -0500
Date: Mon, 4 Jan 2010 07:31:15 -0800
From: Greg KH <greg@kroah.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
       Ashwin Ganti <ashwin.ganti@gmail.com>
Subject: Re: Staging tree status for the .33 kernel merge
Message-ID: <20100104153115.GB9435@kroah.com>
References: <20091223005447.GA28941@kroah.com> <20100104065755.GA26627@hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100104065755.GA26627@hallyn.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 04, 2010 at 12:57:55AM -0600, Serge E. Hallyn wrote:
> Quoting Greg KH (greg@kroah.com):
> ...
> > This means, unless someone steps up and starts doing real work (not
> > trivial spelling fixes) on the following drivers, they will be removed
> > in the future kernel releases.
> > 
> >  - arlan, netwave, strip, wavelan - wireless drivers mentioned above
> >    that are on the way out.  Slated for removal in 2.6.35
> >  - hv - Microsoft Hyper V drivers.  The developers again seem to have
> >    disappeared, this is getting old. Slated for removal in 2.6.35
> >  - p9auth - this will be removed in .34 unless someone steps up.
> 
> I think I've decided to try to push it.  I'm working with some patches
> at git://git.kernel.org/pub/scm/linux/kernel/git/sergeh/linux-cr.git
> (branch p9auth.jan3.4 is latest).  I'll send patches as I feel they
> are ready - so far they pass testcases, but are too new for me to
> feel I should push them today.

Ok, send them on to me when you feel they are good enough.

thanks,

greg k-h
