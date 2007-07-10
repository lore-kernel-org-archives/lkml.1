Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbXGJNbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbXGJNbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 09:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752803AbXGJNbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 09:31:46 -0400
Received: from host.infinivid.com ([64.119.179.76]:47805 "EHLO
	host.infinivid.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633AbXGJNbq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 09:31:46 -0400
Subject: Re: Driver question: multiple instances of same char device
From: Jon Dufresne <jon.dufresne@infinitevideocorporation.com>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <35fbaa3e0707100613r4397bc50h16afe15b89e0bbcb@mail.gmail.com>
References: <1184072796.31808.30.camel@microwave.infinitevideocorporation.com>
	 <35fbaa3e0707100613r4397bc50h16afe15b89e0bbcb@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 09:31:38 -0400
Message-Id: <1184074303.31808.33.camel@microwave.infinitevideocorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

I have been using this book as a source, and it is a great one at that.
I thought I read the char device chapter enough times to get what I
needed out of it but apparently not. I just reread it and realized that
my answer was there.


Thanks again,
Jon

On Tue, 2007-07-10 at 16:13 +0300, Vitaliy Ivanov wrote:
> On 7/10/07, Jon Dufresne <jon.dufresne@infinitevideocorporation.com> wrote:
> > I am relatively new to linux device development. And want to understand
> > Linux conventions.
> >
> > Suppose I have a PCI card that is represented in the system by a
> > character device.
> >
> > If I have two of those PCI cards in the system when the driver module
> > loads, is it convention to have two different major numbers, or have one
> > major number and two different minor numbers?
> >
> > Thanks,
> > Jon
> 
> You can start your kernel hacking way from ldd. It can be found at:
> http://lwn.net/Kernel/LDD3/
> 
> There are a few other books by R. Love or Greg KH that you can read.
> 
> Such questions are fully covered there.
> 
> Best,
> Vitaliy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

