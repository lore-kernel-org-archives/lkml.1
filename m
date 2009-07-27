Return-Path: <linux-kernel-owner+w=401wt.eu-S1755295AbZG0WEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbZG0WEW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 18:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZG0WEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 18:04:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36800 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbZG0WEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 18:04:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephan von Krawczynski <skraw@ithnet.com>
Subject: Re: [Bug #13648] nfsd: page allocation failure
Date: Tue, 28 Jul 2009 00:04:47 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "David Rientjes" <rientjes@google.com>,
       "Justin Piszcz" <jpiszcz@lucidpixels.com>
References: <DizPU9GBfHF.A.kgF.iWObKB@chimera> <H5-1lZIIeYK.A.HXG.DXObKB@chimera> <20090727130420.1514cf5c.skraw@ithnet.com>
In-Reply-To: <20090727130420.1514cf5c.skraw@ithnet.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907280004.47852.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Stephan von Krawczynski wrote:
> On Sun, 26 Jul 2009 22:45:33 +0200 (CEST)
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13648
> > Subject		: nfsd: page allocation failure
> > Submitter	: Justin Piszcz <jpiszcz@lucidpixels.com>
> > Date		: 2009-06-22 12:08 (35 days old)
> > References	: http://lkml.org/lkml/2009/6/22/309
> > 		  http://marc.info/?l=linux-kernel&m=124748600712853&w=4
> > 
> 
> This is no regression between 2.6.29 and 2.6.30.
> In fact we could reproduce the problem with kernel versions:
> 
> 2.6.27.26 < X <= 2.6.30.3
> 
> (Meaning 2.6.27.26 is the last one _not_ showing the problem).

Thanks, moved to the list of regressions from 2.6.27.

Best,
Rafael
