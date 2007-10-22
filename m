Return-Path: <linux-kernel-owner+w=401wt.eu-S1752785AbXJVVea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbXJVVea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 17:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751408AbXJVVeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 17:34:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:12570 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXJVVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 17:34:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=HEm4SjZ82ZKF0T2jv89jwDOfjkyAqHZxk0P1r8JG8kAVxGY99hwNS8XvjybNCcIKxGf0BVAAXAWki+U/CCvwr21NcuGaTt8U+QHp0Op/nhGZrR1PxJtpGmzz7pmHO6bHxszAsjYKRAkbfQ2DXeqwJl38ou5xvCLkXm6ipV7QsWI=
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: rt73usb: support for wireless in Kohjinsha subnotebook
Date: Mon, 22 Oct 2007 23:52:57 +0200
User-Agent: KMail/1.9.7
Cc: Dan Williams <dcbw@redhat.com>, Luis Correia <luis.f.correia@gmail.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
       mwallis@serialmonkey.com
References: <20071020184100.GA11640@elf.ucw.cz> <1193067896.30205.9.camel@localhost.localdomain> <20071022211325.GF28190@elf.ucw.cz>
In-Reply-To: <20071022211325.GF28190@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710222352.57543.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 22 October 2007, Pavel Machek wrote:
> Hi!
> 
> > > > This device is NOT a Ralink USB wifi adapter!
> > > > 
> > > > Get the windows driver in this link and see for yourself.
> > > > http://www.conitech.it/conitech/ita/risorse.asp?cod=CN402USB
> > > > (ISSC W89C35 802.11bg WLAN USB Adapters (Native Wifi driver))
> > > 
> > > Thanks a lot. With some patches, I got driver from conitech.it to
> > > compile and partly work on 2.6.23. I can now transmit packets but not
> > > yet receive them.
> > > 
> > > (use Makefile.26 instead of Makefile)
> > 
> > I couldn't find any license info immediately visible; are you sure it's
> > GPL?
> 
> Yes, I'm quite sure. There's MODULE_LICENCE("GPL"), IIRC.

That doesn't say much, some manufacturers add that line to their driver
 just to prevent the module loader complaining about a non-GPL driver...

There should be a copyright notice or a license file accompanied with
the driver that clearly states the license of the driver.

Ivo
