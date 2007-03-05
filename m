Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXCEUwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXCEUwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 15:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932390AbXCEUwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 15:52:43 -0500
Received: from mailin1.k-net.dk ([82.211.192.11]:3980 "EHLO mailin1.k-net.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932401AbXCEUwl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 15:52:41 -0500
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <200703051932.29996.rjw@sisk.pl>
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172781250.5042.1.camel@localhost.localdomain>
	 <d120d5000703050644x741564v625f0aa7a58c60ad@mail.gmail.com>
	 <200703051932.29996.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Mon, 05 Mar 2007 21:51:38 +0100
Message-Id: <1173127898.10294.1.camel@miraculinux>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-03-05 at 19:32 +0100, Rafael J. Wysocki wrote:
> On Monday, 5 March 2007 15:44, Dmitry Torokhov wrote:
> > On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> > > On Thu, 2007-03-01 at 15:25 -0500, Dmitry Torokhov wrote:
> > > > On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> > > > >
> > > > > Hmmm.
> > > > >
> > > > > Now i get this BUG:
> > > > >
> > > >
> > > > Does it die the same way if you just unload the button driver without
> > > > suspending?
> > > >
> > >
> > > No. Tried unloading and loading 30 times after each other. No problems
> > > at all.
> > >
> > 
> > I wonder what causes unloading of the ACPI button driver during resume...
> 
> Let me guess: pm-utils in OpenSUSE 10.2.
> 
Nope. acpi-support for Debian unstable.

/Kristian


