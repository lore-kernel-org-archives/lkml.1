Return-Path: <linux-kernel-owner+w=401wt.eu-S1755931AbXKBPOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931AbXKBPOY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 11:14:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbXKBPOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 11:14:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64190 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331AbXKBPOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 11:14:15 -0400
Subject: Re: [PATCH] mm: sysfs: expose the BDI object in sysfs
From: Kay Sievers <kay.sievers@vrfy.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Greg KH <greg@kroah.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Fengguang Wu <fengguang.wu@gmail.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Miklos Szeredi <miklos@szeredi.hu>
In-Reply-To: <1194015564.27652.403.camel@twins>
References: <1193410087.6914.34.camel@twins>
	 <1193412836.27652.11.camel@twins> <1193414147.2431.35.camel@lov.site>
	 <1193429066.5648.35.camel@lappy> <1193447889.5648.44.camel@lappy>
	 <20071027024033.GB29039@kroah.com> <1193474399.27652.15.camel@twins>
	 <20071027160203.GA5709@kroah.com> <1193519317.5776.14.camel@lov.site>
	 <1194009359.27652.377.camel@twins>
	 <3ae72650711020650l37870e45yb853f888b4807116@mail.gmail.com>
	 <1194013028.27652.387.camel@twins>  <1194013979.2440.20.camel@lov.site>
	 <1194015564.27652.403.camel@twins>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 16:13:40 +0100
Message-Id: <1194016420.2440.25.camel@lov.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18h//d/YggATUeL3DaGsjrsn8CUfgZaovy1fo4
 V82e6SZgrEI86Dou6lcGdUUQIX6+olk+6lfJlOmo6CoGJJYmq4
 zDkmGUsdEtmP5tkds9WzgXVA/n52q5s
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 15:59 +0100, Peter Zijlstra wrote:
> On Fri, 2007-11-02 at 15:32 +0100, Kay Sievers wrote:
> > On Fri, 2007-11-02 at 15:17 +0100, Peter Zijlstra wrote:

> Here is the 'pretty' patch :-)
> 
> Since it relies on the removal of the device name length limit, this
> should not yet be applied.

Ok, I'll take a look now, and see what's needed here. Would be good to
get that into the next kernel, now that you are waiting for the crap to
get fixed. :)

Thanks,
Kay


