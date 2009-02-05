Return-Path: <linux-kernel-owner+w=401wt.eu-S1762087AbZBECNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762087AbZBECNk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 21:13:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757282AbZBECNa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 21:13:30 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49644 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752313AbZBECN3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 21:13:29 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [Bug #12416] Recent change to kernel spikes out ccache/distcc
Date: Thu, 5 Feb 2009 03:13:02 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jan Beulich <jbeulich@novell.com>, Sam Ravnborg <sam@ravnborg.org>
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.5f.SwYiJB@chimera> <20090205015725.GF8945@mit.edu>
In-Reply-To: <20090205015725.GF8945@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902050313.03605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 05 February 2009, Theodore Tso wrote:
> On Wed, Feb 04, 2009 at 11:23:55AM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12416
> > Subject		: Recent change to kernel spikes out ccache/distcc
> > Submitter	: Theodore Ts'o <tytso@mit.edu>
> > Date		: 2009-01-06 15:15 (30 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123125495000603&w=4
> > Patch		: http://lkml.org/lkml/2009/1/20/78
> 
> This can be closed; Sam reverted the necessary patch the relevent
> commits in 2ea03891, which is in Linus's tree.
> 
> Rafael, I've closed the bug in the Kernel Bugzilla for your convenience.

Great, thanks a lot!

Best,
Rafael
