Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174Ab0AHRnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174Ab0AHRnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 12:43:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916Ab0AHRn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 12:43:29 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:47183 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662Ab0AHRn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 12:43:28 -0500
Message-ID: <9a62ecfffc0d173f5f7fb8ad4c5ce14c.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <201001080920.51979.dmitry.torokhov@gmail.com>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
    <20100108170450.GB8328@elf.ucw.cz> <20100108171329.GA4711@kroah.com>
    <201001080920.51979.dmitry.torokhov@gmail.com>
Date: Fri, 8 Jan 2010 10:43:15 -0700
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
Cc: "Greg KH" <greg@kroah.com>, "Pavel Machek" <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry Torokhov wrote:
> On Friday 08 January 2010 09:13:29 am Greg KH wrote:
>> On Fri, Jan 08, 2010 at 06:04:50PM +0100, Pavel Machek wrote:
>> > On Fri 2010-01-08 09:50:33, Rick L. Vinyard, Jr. wrote:
>> > > Pavel Machek wrote:
>> > > > Hi!
>> > > >
>> > > >> > +static DEVICE_ATTR(name, 0666, g13_name_show, g13_name_store);
>> > > >>
>> > > >> What this attribute is for?
>> > > >
>> > > > Actually, all the new files this added need to be documented.
>> > >
>> > > Which is better? A hid-g13.txt file added to Documentation/ or
>> comments
>> > > in the driver itself?
>> >
>> > Documentation. Coordinate with sysfs maintainer (gregkh).
>>
>> All sysfs files need to be documented in Documentation/ABI/  Please add
>> the documentation there for your new sysfs files.
>
> We need to have an agreement that all of them are needed first though.
>
> --
> Dmitry
>


True. I'm still working through your comments.



