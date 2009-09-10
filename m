Return-Path: <linux-kernel-owner+w=401wt.eu-S1753185AbZIJVKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbZIJVKV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 17:10:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZIJVKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 17:10:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40634 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbZIJVKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 17:10:19 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bob Tracy <rct@gherkin.frus.com>
Subject: Re: [Bug #14136] readcd Oops
Date: Thu, 10 Sep 2009 23:11:26 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc9-rjw; KDE/4.3.1; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michal Schmidt <mschmidt@redhat.com>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.p8B.DfBpKB@chimera> <20090907053833.GA15287@gherkin.frus.com>
In-Reply-To: <20090907053833.GA15287@gherkin.frus.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909102311.26544.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 September 2009, Bob Tracy wrote:
> On Sun, Sep 06, 2009 at 07:24:57PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.30.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14136
> > Subject		: readcd Oops
> > Submitter	: Bob Tracy <rct@gherkin.frus.com>
> > Date		: 2009-09-03 3:39 (4 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125195043617418&w=4
> > Handled-By	: Michal Schmidt <mschmidt@redhat.com>
> > Patch		: http://patchwork.kernel.org/patch/45347/
> 
> I ack'd the fix a few days ago: please remove this bug entry from the
> list of 2.6.30 regressions.

Hmm.  Has the fix been merged already?

Rafael
