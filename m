Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbYG2QIM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbYG2QIM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 12:08:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYG2QH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 12:07:58 -0400
Received: from mx.sierrawireless.com ([208.81.121.7]:10688 "EHLO
	mx1.sierrawireless.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555AbYG2QH5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 12:07:57 -0400
X-Greylist: delayed 853 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jul 2008 12:07:57 EDT
From: Kevin Lloyd <klloyd@sierrawireless.com>
To: Ben Collins <ben.collins@canonical.com>, Greg KH <gregkh@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Date: Tue, 29 Jul 2008 08:53:33 -0700
Subject: RE: [PATCH 5/7] [airprime] Add support for more devices
Thread-Topic: [PATCH 5/7] [airprime] Add support for more devices
Thread-Index: AcjxhmNtLqQaG2geQcCA/Em/3rkUPgADNHyA
Message-ID: <20719A9A7E5F8040AC0590F6F6C1DF461169F2264A@uscbd-exchmb01.sierrawireless.local>
References: <24762.90.138.930.038.1036103001.ben.collins@canonical.com>
	 <E1KKl4J-00068N-2b@swissweb.swissdisk.com>
	 <20080728195813.6c51450b.akpm@linux-foundation.org>
	 <20080729031752.GA11980@suse.de>  <20080729033001.GA12085@kroah.com>
 <1217341216.6019.143.camel@cunning>
In-Reply-To: <1217341216.6019.143.camel@cunning>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 29 Jul 2008 15:53:40.0215 (UTC) FILETIME=[451E2870:01C8F193]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AirPrime 5220 is supported in the sierra.c driver

-----Original Message-----
From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-owner@vger.kernel.org] On Behalf Of Ben Collins
Sent: Tuesday, July 29, 2008 7:20 AM
To: Greg KH
Cc: Andrew Morton; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
Subject: Re: [PATCH 5/7] [airprime] Add support for more devices

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

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

