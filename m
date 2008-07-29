Return-Path: <linux-kernel-owner+w=401wt.eu-S1759246AbYG2OUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759246AbYG2OUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758569AbYG2OUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:20:22 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59244 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447AbYG2OUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:20:21 -0400
Subject: Re: [PATCH 5/7] [airprime] Add support for more devices
From: Ben Collins <ben.collins@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
In-Reply-To: <20080729033001.GA12085@kroah.com>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
	 <E1KKl4J-00068N-2b@swissweb.swissdisk.com>
	 <20080728195813.6c51450b.akpm@linux-foundation.org>
	 <20080729031752.GA11980@suse.de>  <20080729033001.GA12085@kroah.com>
Content-Type: text/plain
Organization: Canonical
Date: Tue, 29 Jul 2008 10:20:16 -0400
Message-Id: <1217341216.6019.143.camel@cunning>
Mime-Version: 1.0
X-Mailer: Evolution 2.23.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-28 at 20:30 -0700, Greg KH wrote:
> On Mon, Jul 28, 2008 at 08:17:52PM -0700, Greg KH wrote:
> > On Mon, Jul 28, 2008 at 07:58:13PM -0700, Andrew Morton wrote:
> > > On Sun, 20 Jul 2008 21:54:48 -0400 Ben Collins <ben.collins@canonical.com> wrote:
> > > 
> > > > Reference: https://launchpad.net/bugs/208250
> > > > 
> > > > Add support for:
> > > > - Audiovox PC5740
> > > > - Huawei E220
> > > > - Momo design
> > > > - AirPrime 5220
> > > > - Dell Wireless HSDPA 5500
> > > > - Sprint Pantech PX-500
> > > > - Novatel U727
> > > > - Onda MT505UP
> > > 
> > > airprime.c got deleted.
> > 
> > Ben, why did you not cc: the linux-usb mailing list if you are sending
> > USB patches out?  Or at least the USB or USB-serial maintainer :)
> 
> Odd, your original message did CC: me, but I don't see it in my inbox
> anywhere.  My appologies, but you should always cc: the subsystem
> mailing list as well.
> 
> Anyway, check 2.6.27-rc1 for a bunch of these ids already, and feel free
> to send me an update for option.c for the remaining ones.
> 
> thanks,

Will do.

