Return-Path: <linux-kernel-owner+w=401wt.eu-S1751929AbZIKFCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbZIKFCx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 01:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbZIKFCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 01:02:52 -0400
Received: from gherkin.frus.com ([192.158.254.49]:58533 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbZIKFCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 01:02:51 -0400
Date: Fri, 11 Sep 2009 00:02:53 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Michal Schmidt <mschmidt@redhat.com>
Subject: Re: [Bug #14136] readcd Oops
Message-ID: <20090911050253.GA31423@gherkin.frus.com>
References: <2ehA7xoGvXL.A.4PB.3eBpKB@chimera> <Vm51Upp4EV.A.p8B.DfBpKB@chimera> <20090907053833.GA15287@gherkin.frus.com> <200909102311.26544.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200909102311.26544.rjw@sisk.pl>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 10, 2009 at 11:11:26PM +0200, Rafael J. Wysocki wrote:
> On Monday 07 September 2009, Bob Tracy wrote:
> > On Sun, Sep 06, 2009 at 07:24:57PM +0200, Rafael J. Wysocki wrote:
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14136
> > > Subject		: readcd Oops
> > > Submitter	: Bob Tracy <rct@gherkin.frus.com>
> > > Date		: 2009-09-03 3:39 (4 days old)
> > > References	: http://marc.info/?l=linux-kernel&m=125195043617418&w=4
> > > Handled-By	: Michal Schmidt <mschmidt@redhat.com>
> > > Patch		: http://patchwork.kernel.org/patch/45347/
> > 
> > I ack'd the fix a few days ago: please remove this bug entry from the
> > list of 2.6.30 regressions.
> 
> Hmm.  Has the fix been merged already?

Good question: I don't think so.  It's not in mainline as of 2.6.31.
Looks like we need to keep this bug open a while longer...  Sorry 'bout
that.

--Bob
