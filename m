Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935243Ab0COC4L (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 22:56:11 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56702 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934401Ab0COC4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 22:56:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=q/8/QCRhDUDMTP/7gJCYlnTsL/nePYxrghvbvAzbnFgP10bMKCxrnbjgt+QBG5WHX1
         hcEoi445fhNSD9R9/K/dX637OZd+5K5jkUB6yLeeFQckvbZZBjZbcnWmdhklOM178wGY
         8GF6H3xfnEHuO94IKEVbx1dmP/6ePAOiCr6es=
MIME-Version: 1.0
In-Reply-To: <201003150326.22262.vda.linux@googlemail.com>
References: <4B947393.2050002@kernel.org>
	 <1158166a1003100114j6ea329fbh84bfad65dcac90bf@mail.gmail.com>
	 <4B9D8BB2.1010507@zytor.com>
	 <201003150326.22262.vda.linux@googlemail.com>
Date: Sun, 14 Mar 2010 22:56:07 -0400
Message-ID: <87f94c371003141956t6115f45bga5ec1e6d76b1ea40@mail.gmail.com>
Subject: Re: ATA 4 KiB sector issues.
From: Greg Freemyer <greg.freemyer@gmail.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
       Tejun Heo <tj@kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just played with ubuntu installation on an usb stick.
> Yes, it works. Soft of. Write performance is abysmal.
> I would pay x2 or x3 for the same sized stick if it
> would perform better.

In general USB sticks don't offer the same performance as SSDs.

You can find sticks with both USB and eSata.  I'd hope those offer
better performance.

You should read some performance reviews.  I'm sure you can find a few
sticks that are much better than what you get from a vanilla usb
stick.

Greg
