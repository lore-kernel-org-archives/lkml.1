Return-Path: <linux-kernel-owner+w=401wt.eu-S1757620AbXFVXtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620AbXFVXtk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 19:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752751AbXFVXtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 19:49:32 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:48205 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586AbXFVXtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 19:49:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=XhZwuzO3Dg43GUkWEjZXmF8SfRxggCx75yE/67IrM5/YKPKfYmcWpbev7tJAwT/Kad0wCVZrMTGVnZQDOrOkyMrJBqqwJ4xOY6XaMbqMX51Md/7U5M05tTSMy6R0JqduMVLfr1UqHm2Ccqto+c4E3ryGUw9jfgKrO9S0mw6khDc=
Message-ID: <a781481a0706221649j19f9ce2apcf295ddf9530da1e@mail.gmail.com>
Date: Sat, 23 Jun 2007 05:19:30 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re: [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
Cc: "Trent Piepho" <xyzzy@speakeasy.org>,
       "Mauro Carvalho Chehab" <mchehab@infradead.org>, toralf.foerster@gmx.de,
       "Oliver Neukum" <oneukum@suse.de>, LKML <linux-kernel@vger.kernel.org>,
       "Jan Engelhardt" <jengelh@linux01.gwdg.de>,
       "Luca Risolia" <luca.risolia@studio.unibo.it>
In-Reply-To: <Pine.LNX.4.64.0706230137090.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706211117.55908.toralf.foerster@gmx.de>
	 <Pine.LNX.4.58.0706221259500.4914@shell4.speakeasy.net>
	 <a781481a0706221420u6935e75er1ee5601e013b40d2@mail.gmail.com>
	 <Pine.LNX.4.64.0706222336210.1817@scrub.home>
	 <a781481a0706221501s4887f88bh3b8cc549deb6886e@mail.gmail.com>
	 <Pine.LNX.4.64.0706230017430.1817@scrub.home>
	 <a781481a0706221533j34c341c5gf7ff92997e2463a6@mail.gmail.com>
	 <Pine.LNX.4.64.0706230049480.1817@scrub.home>
	 <a781481a0706221626q17f533ccnac09b2cc7c89126d@mail.gmail.com>
	 <Pine.LNX.4.64.0706230137090.1817@scrub.home>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 6/23/07, Roman Zippel <zippel@linux-m68k.org> wrote:
> Hi,
>
> On Sat, 23 Jun 2007, Satyam Sharma wrote:
>
> > Yup, so how / why am I wrong? I was making the point that a
> > "menuconfig" does not have code associated with it.
>
> Which is wrong, it's not and will not be limited to this.

But why? Let it do just one thing, and do it well. Is their
any requirement anywhere that requires us to give a dual
meaning to these menuconfig objects -- i.e. to also control
the inclusion / exclusion of code from the kernel as well as
also for the presentation + user interface purpose that it
currently serves?

Satyam
