Return-Path: <linux-kernel-owner+w=401wt.eu-S1754933AbYLISQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754933AbYLISQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 13:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753483AbYLISQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 13:16:45 -0500
Received: from kroah.org ([198.145.64.141]:42235 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753731AbYLISQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 13:16:45 -0500
Date: Tue, 9 Dec 2008 09:58:48 -0800
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Greg KH <gregkh@suse.de>, "Theodore Ts'o" <tytso@mit.edu>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>, torvalds@linux-foundation.org,
       Eugene Teo <eteo@redhat.com>, Justin Forbes <jmforbes@linuxtx.org>,
       linux-kernel@vger.kernel.org, Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Domenico Andreoli <cavokz@gmail.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Willy Tarreau <w@1wt.eu>,
       Michael Krufky <mkrufky@linuxtv.org>, alan@lxorguk.ukuu.org.uk,
       Chuck Ebbert <cebbert@redhat.com>, Dave Jones <davej@redhat.com>,
       akpm@linux-foundation.org, Jake Edge <jake@lwn.net>,
       Chuck Wolber <chuckw@quantumlinux.com>, stable@kernel.org,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Pavel Machek <pavel@suse.cz>
Subject: Re: [stable] [patch 000/104] 2.6.27-stable review
Message-ID: <20081209175848.GA8024@kroah.com>
References: <20081203194725.GA8950@kroah.com> <200812032239.14280.rjw@sisk.pl> <200812050133.11325.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200812050133.11325.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 01:33:10AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, 3 of December 2008, Rafael J. Wysocki wrote:
> > Hi Greg,
> > 
> > On Wednesday, 3 of December 2008, Greg KH wrote:
> > > This is the start of the stable review cycle for the 2.6.27.8 release.
> > > There are 104 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let us know.  If anyone is a maintainer of the proper subsystem, and
> > > wants to add a Signed-off-by: line to the patch, please respond with it.
> > > 
> > > And yes, there are a lot of patches here, the big series are:
> > > 	- cifs data corruption patches
> > > 	- pci hotplug slot patches to fix the most common warning
> > > 	  showing up on kerneloops.org
> > > 	- ext4 bugfixes
> > > 
> > > These patches are sent out with a number of different people on the Cc:
> > > line.  If you wish to be a reviewer, please email stable@kernel.org to
> > > add your name to the list.  If you want to be off the reviewer list,
> > > also email us.
> > > 
> > > Responses should be made by Friday, December 5, 20:00:00 UTC.  Anything
> > > received after that time might be too late.
> > 
> > The following ACPI commits are also -stable material IMO:
> > 
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=65df78473ffbf3bff5e2034df1638acc4f3ddd50
> 
> Argh, the following one is broken:
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=558073dd56707864f09d563b64e7c37c021e89d2
> 
> so please scratch it and this one is already on your list:
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=7b4d469228a92a00e412675817cedd60133de38a
> 
> The remaining two, ie.
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=65df78473ffbf3bff5e2034df1638acc4f3ddd50 http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=40599072dca3ec7d4c9ff8271978be169f974638

I've now queued these two up.

If there is anything else that you think I need to add for the next
-stable release for 2.6.27, please let me know.

thanks,

greg k-h
