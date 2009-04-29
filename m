Return-Path: <linux-kernel-owner+w=401wt.eu-S1760651AbZD2Uka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760651AbZD2Uka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 16:40:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZD2UkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 16:40:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:20165 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbZD2UkR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 16:40:17 -0400
MIME-Version: 1.0
In-Reply-To: <20090429200032.GD1598@khazad-dum.debian.net>
References: <20090427193532.GA2948@kroah.com> <8bd0f97a0904291053g3aa71decpd33f6621ad0bf9f8@mail.gmail.com> 
	<20090429180735.GA29812@kroah.com> <8bd0f97a0904291117ic07fadcs2a02fca3dcfefcf0@mail.gmail.com> 
	<ac3eb2510904291159s14d7d532q33657eb73007fc4b@mail.gmail.com> 
	<20090429191841.GA1598@khazad-dum.debian.net> <ac3eb2510904291227v48628c8j181dffc8fdfa1de6@mail.gmail.com> 
	<20090429195037.GC1598@khazad-dum.debian.net> <ac3eb2510904291255j2aee527bx8e32b356ad0260d1@mail.gmail.com> 
	<20090429200032.GD1598@khazad-dum.debian.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 29 Apr 2009 22:39:56 +0200
Message-ID: <ac3eb2510904291339y13471168y7cb0dbcb9f967c82@mail.gmail.com>
Subject: Re: usbutils 0.81 release
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Mike Frysinger <vapier.adi@gmail.com>, Greg KH <greg@kroah.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 22:00, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Wed, 29 Apr 2009, Kay Sievers wrote:
>> And if your distro updates the package, it overwrites the changes you
>> did to the file, and they are lost?
>
> I suppose so, and not just for package updates: if you run update-usbids,
> the old one is overwritten AFAIK.  I didn't check the scripts, though.  But
> as a long time Debian Developer and user, that's what is implied by its
> location in /var.

Ah, ok, that sounds fine, if that is still one and the same file, and
not a "lookup in several locations and pick one" logic.

> If local admin changes are to be preserved, Debian policy mandates that it
> belongs on /etc.

Sounds a bit special, but if that is the ways it works, and people
know that, it's fine I guess.

Thanks,
Kay
