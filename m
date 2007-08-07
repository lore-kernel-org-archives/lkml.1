Return-Path: <linux-kernel-owner+w=401wt.eu-S1759454AbXHGItj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759454AbXHGItj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 04:49:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757295AbXHGItc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 04:49:32 -0400
Received: from fk-out-0910.google.com ([209.85.128.188]:11961 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756320AbXHGItb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 04:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IXSQzoFo2Y0TItWMg0pRY45MrlAEiQqPZBVQ1vPdwqcFUmHYwvWmvzrzWUgpM0ZEmgwadxTcD8Owfx8yzyoyZH6EH0EtTDktvn0bv2jodduFnXzYA24f+bsdpFNGcFCHIpEIFKa/y9kYo+HRMGLEpFUMkIf9Iq3KhCcamUvt/uE=
From: Christoph Pfister <christophpfister@gmail.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: BUG: soft lockup detected on CPU#0!
Date: Tue, 7 Aug 2007 10:49:23 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <19a3b7a80707251241t1cb5389ak8e5e3b27af2bde41@mail.gmail.com> <6bffcb0e0707271230s1f3f3c63w8ccdd8a0945e706a@mail.gmail.com> <19a3b7a80707271304g231860b8g690a32b12cac5835@mail.gmail.com>
In-Reply-To: <19a3b7a80707271304g231860b8g690a32b12cac5835@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708071049.23226.christophpfister@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Am Freitag, 27. Juli 2007 22:04 schrieb Christoph Pfister:
> Hi Michal,
>
> 2007/7/27, Michal Piotrowski <michal.k.k.piotrowski@gmail.com>:
> > Hi Christoph,
> >
> > On 25/07/07, Christoph Pfister <christophpfister@gmail.com> wrote:
> > > Hi,
> > >
> > > After burning a dvd I had to eject it and found that message in dmesg.
> > > Syslog snippet and dmesg attached.
> > > System is 2.6.21 (debian version), running a p4, issue reproducible.
> >
> > Does this happen on the latest -stable?
> > http://eu.kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2

Doesn't happen there anymore.

> I'm on holiday really soon - but will try when I'm back :)
>
> > > Thanks for taking care of this,
> > >
> > > Christoph
> >
> > Regards,
> > Michal
>
> Christoph

Thanks,

Christoph
