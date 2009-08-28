Return-Path: <linux-kernel-owner+w=401wt.eu-S1752122AbZH1SzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752122AbZH1SzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 14:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768AbZH1SzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 14:55:21 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:44569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751529AbZH1SzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 14:55:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [Bug #14015] pty regressed again, breaking expect and gcc's testsuite
Date: Fri, 28 Aug 2009 20:56:10 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-rc6-rjw; KDE/4.3.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <riPp5fx5ECC.A.2IG.qsGlKB@chimera> <_yaHeGjHEzG.A.tMH.9sGlKB@chimera> <19094.58486.867940.103340@pilspetsen.it.uu.se>
In-Reply-To: <19094.58486.867940.103340@pilspetsen.it.uu.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908282056.10251.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 August 2009, Mikael Pettersson wrote:
> On Tue, 25 Aug 2009 22:34:53 +0200 (CEST), Rafael J. Wysocki wrote:
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D14015
> > Subject		: pty regressed again, breaking expect and gcc's testsuite
> > Submitter	: Mikael Pettersson <mikpe@it.uu.se>
> > Date		: 2009-08-14 23:41 (12 days old)
> > References	: http://marc.info/?l=3Dlinux-kernel&m=3D125029329805643&w=3D4
> 
> Not fixed. With 2.6.31-rc7 I'm still seeing repeatable testsuite
> failures on powerpc64. Reverting to 2.6.30 makes the failures go away.

Thanks for the update.

I guess 2.6.31-rc8 doesn't make any difference, does it?

Rafael
