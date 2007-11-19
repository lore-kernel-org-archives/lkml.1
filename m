Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXKSTF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXKSTF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 14:05:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754655AbXKSTFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 14:05:40 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39568 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751612AbXKSTFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 14:05:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Chris Friedhoff <chris@friedhoff.org>
Subject: Re: 2.6.24-rc2 STD with s2disk fails to activate suspended system after loading - now 2.6.24-rc3
Date: Mon, 19 Nov 2007 20:22:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20071110221629.1d180480.chris@friedhoff.org> <20071119144200.6026ce62.chris@friedhoff.org> <200711191958.36570.rjw@sisk.pl>
In-Reply-To: <200711191958.36570.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711192022.59652.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 19 of November 2007, Rafael J. Wysocki wrote:
> On Monday, 19 of November 2007, Chris Friedhoff wrote:
> > Hallo Rafael,
> > 
> > just to let you know: with 2.6.24-rc3 I have the same problem.
> 
> Thanks.
>  
> > On Sun, 11 Nov 2007 19:45:06 +0100
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > > On Saturday, 10 of November 2007, Chris Friedhoff wrote:
> > > > please cc me, I'm not not subscribed to LKML
> > > > 
> > > > Hello,
> > > > 
> > > > with kernel 2.6.24-rc2 STD with s2disk suspends the system to disk, but
> > > > when I start the system and the suspended systemimage is loaded, it
> > > > fails to "activate" this suspended systemimage and continues after some
> > > > time with following the normal boot sequence.
> 
> Please add the dmesg output taken right after that

I mean, just when the system boots after that.

> as an attachment to the bugzilla entry at
> http://bugzilla.kernel.org/show_bug.cgi?id=9345 

Thanks,
Rafael
