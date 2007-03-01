Return-Path: <linux-kernel-owner+w=401wt.eu-S965322AbXCAQYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965322AbXCAQYU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 11:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965330AbXCAQYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 11:24:20 -0500
Received: from mailin1.k-net.dk ([82.211.192.11]:4496 "EHLO mailin1.k-net.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965322AbXCAQYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 11:24:19 -0500
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <d120d5000703010701y44ba3cfcxf58e1897fe47a4d6@mail.gmail.com>
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172622441.4587.14.camel@localhost.localdomain>
	 <200702281345.15098.rjw@sisk.pl> <200703010036.28166.dtor@insightbb.com>
	 <1172760952.21416.110.camel@miraculinux>
	 <d120d5000703010701y44ba3cfcxf58e1897fe47a4d6@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Mar 2007 17:23:15 +0100
Message-Id: <1172766195.5543.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 10:01 -0500, Dmitry Torokhov wrote:
> On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> > On Thu, 2007-03-01 at 00:36 -0500, Dmitry Torokhov wrote:
> > >
> > > Please try the patch below.
> >
> > Hmmm. Is the diff against 2.6.20? All hunks except one fails when i try
> > it. If I pass "-F 3" to patch, then one more hunk succeeds. Am I doing
> > something wrong?
> >
> 
> Hm, technically speaking it is against 2.6.21-rc2 but I think exceppt
> for tsdev part it should apply to 2.6.20...
> 

OK. Something went wrong when copy pasting the patch to a file. Saved
the entire mail, and applied it succesfully to 2.6.21-r2. Still only a
couple of successfull hunks against 2.6.20. I'm compiling 2.6.21-rc2
right now, and then I'll try to see if the problem persists.

/Kristian
