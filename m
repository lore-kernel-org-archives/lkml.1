Return-Path: <linux-kernel-owner+w=401wt.eu-S1752695AbZG1UPx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695AbZG1UPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 16:15:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752187AbZG1UPx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 16:15:53 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34206 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZG1UPw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 16:15:52 -0400
Subject: Re: [Bug #13845] inotify regression, missing events
From: Eric Paris <eparis@redhat.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Scott James Remnant <scott@ubuntu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200907280052.44653.rjw@sisk.pl>
References: <Jya1GruKQpD.A.16.2GObKB@chimera>
	 <3zAHs5O6maO.A.ATB.-GObKB@chimera> <1248683738.22308.0.camel@quest>
	 <200907280052.44653.rjw@sisk.pl>
Content-Type: text/plain
Date: Tue, 28 Jul 2009 16:15:02 -0400
Message-Id: <1248812102.15671.0.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-28 at 00:52 +0200, Rafael J. Wysocki wrote:
> On Monday 27 July 2009, Scott James Remnant wrote:
> > On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
> > 
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.30.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13845
> > > Subject		: inotify regression, missing events
> > > Submitter	: Scott James Remnant <scott@ubuntu.com>
> > > Date		: 2009-07-11 16:02 (16 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=124732816314881&w=4
> > > Handled-By	: Eric Paris <eparis@redhat.com>
> > > 
> > This patch hasn't found its way into Linus' tree yet, so it's definitely
> > still an issue and should be listed.
> 
> Thanks for the update

Looks like it was pulled into Linus's tree last night if you would like
to test and verify.

-Eric

