Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYDLUUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYDLUUu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2008 16:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYDLUUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Apr 2008 16:20:41 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:51434 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756518AbYDLUUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2008 16:20:40 -0400
X-Greylist: delayed 2660 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Apr 2008 16:20:39 EDT
Subject: Re: Kernel Oops on hot insertion of USB
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Greg KH <greg@kroah.com>, "Rachmel, Nir (Nir)" <rachmel@avaya.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <86802c440804121208g1ee18b62y50a075afa66ff7c6@mail.gmail.com>
References: <11486DD9B957EA488E21C44BC8737EFC987F23@307622ANEX5.global.avaya.com>
	 <20080412042918.GA13154@kroah.com>
	 <11486DD9B957EA488E21C44BC8737EFC55F379@307622ANEX5.global.avaya.com>
	 <20080412165919.GA30848@kroah.com>
	 <86802c440804121208g1ee18b62y50a075afa66ff7c6@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Date: Sat, 12 Apr 2008 21:47:33 +0200
Message-Id: <1208029653.16169.1.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lør, 12 04 2008 kl. 12:08 -0700, skrev Yinghai Lu:
> On Sat, Apr 12, 2008 at 9:59 AM, Greg KH <greg@kroah.com> wrote:
> >  > I have done much work and testing with 2.6.14.7 and would
> >  > prefer to patch it over upgrading it to the current version.
> >
> >  Hopefully you are able to patch all of the bugs and security issues that
> >  have been found in the past 3 years.
> 
> should be typo. Is there any 2.6.14.7 ?, it could be 2.6.24.7
> 
Yes, there is a 2.6.14.7, see the ChangeLog at
http://kernel.org/pub/linux/kernel/v2.6/ChangeLog-2.6.14.7


Simon Holm Thøgersen

