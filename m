Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbZG2VLe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbZG2VLe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 17:11:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZG2VLd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 17:11:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49702 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218AbZG2VLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 17:11:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Scott James Remnant <scott@ubuntu.com>
Subject: Re: [Bug #13845] inotify regression, missing events
Date: Wed, 29 Jul 2009 23:12:07 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc4-rjw; KDE/4.2.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <Jya1GruKQpD.A.16.2GObKB@chimera> <1248812102.15671.0.camel@localhost> <1248869060.23840.10.camel@quest>
In-Reply-To: <1248869060.23840.10.camel@quest>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907292312.08393.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 July 2009, Scott James Remnant wrote:
> On Tue, 2009-07-28 at 16:15 -0400, Eric Paris wrote:
> 
> > On Tue, 2009-07-28 at 00:52 +0200, Rafael J. Wysocki wrote:
> > > On Monday 27 July 2009, Scott James Remnant wrote:
> > > > On Sun, 2009-07-26 at 22:28 +0200, Rafael J. Wysocki wrote:
> > > > 
> > > > > This message has been generated automatically as a part of a report
> > > > > of recent regressions.
> > > > > 
> > > > > The following bug entry is on the current list of known regressions
> > > > > from 2.6.30.  Please verify if it still should be listed and let me know
> > > > > (either way).
> > > > > 
> > > > > 
> > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13845
> > > > > Subject		: inotify regression, missing events
> > > > > Submitter	: Scott James Remnant <scott@ubuntu.com>
> > > > > Date		: 2009-07-11 16:02 (16 days old)
> > > > > References	: http://marc.info/?l=linux-kernel&m=124732816314881&w=4
> > > > > Handled-By	: Eric Paris <eparis@redhat.com>
> > > > > 
> > > > This patch hasn't found its way into Linus' tree yet, so it's definitely
> > > > still an issue and should be listed.
> > > 
> > > Thanks for the update
> > 
> > Looks like it was pulled into Linus's tree last night if you would like
> > to test and verify.
> > 
> Tested and verified, good work!

Thanks, bug closed.

Rafael
