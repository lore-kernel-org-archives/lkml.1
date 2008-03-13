Return-Path: <linux-kernel-owner+w=401wt.eu-S1753542AbYCMJPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbYCMJPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 05:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbYCMJPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 05:15:39 -0400
Received: from www.tglx.de ([62.245.132.106]:35061 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752585AbYCMJPi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 05:15:38 -0400
Date: Thu, 13 Mar 2008 10:13:22 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Ben Nizette <bn@niasdigital.com>
Cc: gregkh <gregkh@suse.de>, linux-kernel <linux-kernel@vger.kernel.org>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v2] UIO: Implement a UIO interface for the SMX
 Cryptengine
Message-ID: <20080313101322.15ddfbb6@dilbert.local>
In-Reply-To: <1205399220.3735.4.camel@moss.renham>
References: <1205316382.4344.15.camel@moss.renham>
	<20080313095301.4aea6d0e@dilbert.local>
	<1205399220.3735.4.camel@moss.renham>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 13 Mar 2008 20:07:00 +1100
schrieb Ben Nizette <bn@niasdigital.com>:

> 
> On Thu, 2008-03-13 at 09:53 +0100, Hans-Jürgen Koch wrote:
> > Am Wed, 12 Mar 2008 21:06:22 +1100
> > schrieb Ben Nizette <bn@niasdigital.com>:
> > > 
> > > This is version 2 of this patch and addresses all issues raised by
> > > Hans-Jürgen Koch in his review of version 1.
> > 
> > But it doesn't address the issue Paul Mundt has raised. As this driver will
> > probably serve as an example for other UIO platform drivers, it should be
> > correct. And I also consider it a bit impolite if you completely ignore Paul,
> > who has taken the time to review your driver and pointed out a mistake. His
> > solution is obviously the correct one.
> > 
> 
> Unfortunately v2 of this patch missed Paul's comments by about a minute.
> I have made his change and was waiting any comments on this version
> before I pushed out a v3.

OK, send it. You should have done so immediately. It's seldom a good idea to
post a patch with known issues, because it wastes people's time reviewing a
patch that is not acceptable in the first place.

> 
> I too am hoping this will serve as an example to people who previously
> have just used /dev/mem and polled the device; I'm very much committed
> to getting it right!

OK. Thank you very much for your work. I receive lots of mails from people
who want to know how such an UIO platform driver is done, so I'm glad to have
a nice example here.

Thanks,
Hans

