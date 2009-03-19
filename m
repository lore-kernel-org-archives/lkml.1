Return-Path: <linux-kernel-owner+w=401wt.eu-S1756194AbZCSNDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194AbZCSNDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 09:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZCSNDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 09:03:15 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40032 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335AbZCSNDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:03:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Subject: Re: [Bug #12574] possible circular locking dependency detected
Date: Thu, 19 Mar 2009 14:03:27 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc8-tst; KDE/4.2.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <MiincthRUSI.A.eKC.F4BvJB@chimera> <GCLaknAim2M.A.pCF.R6BvJB@chimera> <20090316002404.GA12662@google.com>
In-Reply-To: <20090316002404.GA12662@google.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903191403.28095.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 16 March 2009, Michael S. Tsirkin wrote:
> On Sat, Mar 14, 2009 at 08:05:29PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12574
> > Subject		: possible circular locking dependency detected
> > Submitter	: Michael S. Tsirkin <m.s.tsirkin@gmail.com>
> > Date		: 2009-01-29 11:35 (45 days old)
> > References	: http://lkml.org/lkml/2009/2/9/205
> > 
> 
> It's still there in rc8.

Thanks for the update.

Rafael
