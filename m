Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab0CITjz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 14:39:55 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:16739 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0CITjx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 14:39:53 -0500
X-IronPort-AV: E=Sophos;i="4.49,610,1262581200"; 
   d="scan'208";a="13858907"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Analog Devices, Inc.
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [git pull] Input updates for 2.6.34-rc0
Date: Tue, 9 Mar 2010 14:39:48 -0500
User-Agent: KMail/1.9.5
CC: Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>
References: <20100301080342.GH765@core.coreip.homeip.net> <8bd0f97a1003091013q565f8b1bse66b48d9c9a25600@mail.gmail.com> <20100309182013.GC19814@core.coreip.homeip.net>
In-Reply-To: <20100309182013.GC19814@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-ID: <201003091439.49023.rgetz@blackfin.uclinux.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 9 Mar 2010 13:20, Dmitry Torokhov pondered:
> On Tue, Mar 09, 2010 at 01:13:34PM -0500, Mike Frysinger wrote:
> > On Tue, Mar 9, 2010 at 13:10, Dmitry Torokhov wrote:
> > > On Tue, Mar 09, 2010 at 12:58:24PM -0500, Mike Frysinger wrote:
> > >> On Tue, Mar 9, 2010 at 12:51, Dmitry Torokhov wrote:
> > >> > On Tue, Mar 09, 2010 at 09:44:08AM -0500, Mike Frysinger wrote:
[snip]
> > >> i understand the ADXL34x is a bit wonky, but what else would you
> > >> propose ?  or just leave the driver in limbo forever until people
> > >> forget about it ?
> > >
> > > No, just till we have proper framework for it to be merged into.
> > 
> > that sounds fine, but is there actually something in progress for that
> > ?  waiting for a framework no one is working on is the same in
> > practice ...
> 
> I have high hopes that IIO will fill the needs of these kinds of devices.

The fact of things is that many people are using this as pointing device.

I'm not convinced that IIO is the best place for these types of things...

