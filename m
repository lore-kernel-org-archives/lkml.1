Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbYCMKHv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbYCMKHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 06:07:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755120AbYCMKHY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 06:07:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:35957 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754999AbYCMKHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 06:07:22 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+VltI3l4yVQsf2F+44PUY9YMWcy4UVJ+bWFkV560
	TLdaRaOk6K6b6I
Date: Thu, 13 Mar 2008 11:07:28 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Yinghai Lu <yhlu.kernel@gmail.com>
cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Len Brown <len.brown@intel.com>
Subject: Re: pcibios_scanned needs to be set in ACPI? (was Re: 2.6.25-rc5:
 Reported regressions from 2.6.24)
In-Reply-To: <86802c440803122324w1de8dee2ud35c20c7a696b6b4@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803131106140.4625@axis700.grange>
References: <alpine.LFD.1.00.0803101913340.5896@woody.linux-foundation.org>
  <200803112341.42517.rjw@sisk.pl>  <alpine.LFD.1.00.0803121300160.3557@woody.linux-foundation.org>
  <20080312203205.GB17187@kroah.com> <20080312212704.GA16836@kroah.com> 
 <20080312213826.GA17101@kroah.com>  <alpine.LFD.1.00.0803121521550.3557@woody.linux-foundation.org>
  <20080312225421.GA24449@kroah.com>  <alpine.LFD.1.00.0803121604580.3557@woody.linux-foundation.org>
  <20080313054400.GA17102@kroah.com> <86802c440803122324w1de8dee2ud35c20c7a696b6b4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Yinghai Lu wrote:

> wonder if
> 
> http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=fff07473e243989a2739b9d802d63e051ade7188
> 
> helps.

Firstly, it doesn't apply to -rc4-ish, secondly, no, after applying it 
manually, it didn't improve anything.

Thanks
Guennadi
---
Guennadi Liakhovetski
