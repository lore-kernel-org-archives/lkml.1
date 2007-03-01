Return-Path: <linux-kernel-owner+w=401wt.eu-S1030194AbXCAUfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030194AbXCAUfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 15:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030228AbXCAUfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 15:35:08 -0500
Received: from mailin1.k-net.dk ([82.211.192.11]:1152 "EHLO mailin1.k-net.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030194AbXCAUfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 15:35:07 -0500
Subject: Re: PROBLEM: "BUG:" when resuming from suspend-to-ram
From: Kristian =?ISO-8859-1?Q?Gr=F8nfeldt_S=F8rensen?= <kriller@vkr.dk>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@atrey.karlin.mff.cuni.cz, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <d120d5000703011225t1ffaa33akbfcde29d2954601e@mail.gmail.com>
References: <1172601905.5428.28.camel@localhost.localdomain>
	 <1172622441.4587.14.camel@localhost.localdomain>
	 <200702281345.15098.rjw@sisk.pl> <200703010036.28166.dtor@insightbb.com>
	 <1172779492.7396.2.camel@localhost.localdomain>
	 <d120d5000703011225t1ffaa33akbfcde29d2954601e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Mar 2007 21:34:10 +0100
Message-Id: <1172781250.5042.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-01 at 15:25 -0500, Dmitry Torokhov wrote:
> On 3/1/07, Kristian Grønfeldt Sørensen <kriller@vkr.dk> wrote:
> >
> > Hmmm.
> >
> > Now i get this BUG:
> >
> 
> Does it die the same way if you just unload the button driver without
> suspending?
> 

No. Tried unloading and loading 30 times after each other. No problems
at all.

/Kristian

