Return-Path: <linux-kernel-owner+w=401wt.eu-S1755973AbZGGLHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755973AbZGGLHe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 07:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbZGGLH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 07:07:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:32829 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753108AbZGGLH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 07:07:26 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rob Landley <rob@landley.net>
Subject: Re: [Bug #13668] Can't boot 2.6.30 powerpc kernel under qemu.
Date: Tue, 7 Jul 2009 13:08:07 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc2-rjw; KDE/4.2.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
       "Jeremy Kerr" <jk@ozlabs.org>
References: <tSdKBEwEOhE.A.2wF.s_oUKB@chimera> <bXZeuxPQAWE.A.RDG.3_oUKB@chimera> <200907062149.35062.rob@landley.net>
In-Reply-To: <200907062149.35062.rob@landley.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071308.08380.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 July 2009, Rob Landley wrote:
> On Monday 06 July 2009 19:01:05 Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.29 and 2.6.30.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
> > be listed and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13668
> > Subject		: Can't boot 2.6.30 powerpc kernel under qemu.
> > Submitter	: Rob Landley <rob@landley.net>
> > Date		: 2009-06-27 18:08 (10 days old)
> > References	: http://lkml.org/lkml/2009/6/27/159
> 
> Resolved, it just required a configuration change.

Thanks, closed.

Best,
Rafael
