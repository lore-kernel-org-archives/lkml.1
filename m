Return-Path: <linux-kernel-owner+w=401wt.eu-S1763935AbXHKVl3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763935AbXHKVl3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2007 17:41:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760775AbXHKVlU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Aug 2007 17:41:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56010 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760375AbXHKVlU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2007 17:41:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Subject: Re: resume from ram much slower
Date: Sat, 11 Aug 2007 23:50:54 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <200708101848.37222.arekm@maven.pl> <200708102200.10840.rjw@sisk.pl> <200708111104.29138.arekm@maven.pl>
In-Reply-To: <200708111104.29138.arekm@maven.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708112350.54958.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 11 August 2007 11:04, Arkadiusz Miskiewicz wrote:
> On Friday 10 of August 2007, Rafael J. Wysocki wrote:
> > On Friday, 10 August 2007 18:48, Arkadiusz Miskiewicz wrote:
> > > Hi,
> > >
> > > Starting 1-2 weeks ago I have very long resume from
> > > ram times. It takes more than 1 min to resume. Does anyone see such
> > > behaviour?
> > >
> > > Kernel from yesterday git, thinkpad z60m, suspend.sf.net tools 20070801
> > >
> > > "ACPI handle has no context!" are interesting btw.
> >
> > Let's try to find out something.
> >
> > Please apply the patch below and see if anything changes.
> 
> dmesg below. Nothing changes. I guess bisecting is going to be needed.

Yes, I guess so.
