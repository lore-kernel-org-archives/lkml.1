Return-Path: <linux-kernel-owner+w=401wt.eu-S1763557AbYBTR4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763557AbYBTR4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 12:56:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761215AbYBTRzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 12:55:39 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:54554 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbYBTRzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 12:55:33 -0500
Date: Wed, 20 Feb 2008 08:47:47 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andy Whitcroft <apw@shadowen.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: first tree
Message-Id: <20080220084747.77553451.randy.dunlap@oracle.com>
In-Reply-To: <20080221012332.dc1948ac.sfr@canb.auug.org.au>
References: <20080215003537.8911ce35.sfr@canb.auug.org.au>
	<20080214160231.GC10713@shadowen.org>
	<20080221012332.dc1948ac.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2008 01:23:32 +1100 Stephen Rothwell wrote:

> Hi Andy,
> 
> On Thu, 14 Feb 2008 16:04:36 +0000 Andy Whitcroft <apw@shadowen.org> wrote:
> >
> > As devout believers in testing things early we test -mm and -git releases
> > as they drop.  I am keen that we are able to continue this with the -next
> > tree once it gets going.  Having just pulled this tree its not obvious how
> > I would communicate which tree I had tested.  I guess we could use the
> > SHA1 of the actual head used, but that really is cumbersome for the poor
> > people who have to check the results and actually report things to lkml.
> 
> I hope I have addressed this issue by tagging each tree with its date
> i.e. todays was next-20080220.
> 
> > Also will you be producing any tarballs for these releases?  If so I
> > would say they would definatly need to be against some common base, like
> > against the nearest official tag "below".
> 
> I hadn't considered tarballs, but I will give it some thought.

I'd like to see tarballs too, please...

---
~Randy
