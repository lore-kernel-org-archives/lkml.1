Return-Path: <linux-kernel-owner+w=401wt.eu-S1758000AbYFWOuY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000AbYFWOuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 10:50:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754495AbYFWOuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 10:50:10 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56941 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421AbYFWOuJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:50:09 -0400
Subject: Re: [Cluster-devel] Re: [Bug 10827] 2.6.26rc4 GFS2 oops.
From: Bob Peterson <rpeterso@redhat.com>
Reply-To: rpeterso@redhat.com
To: Adrian Bunk <bunk@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, cluster-devel@redhat.com,
       Dave Jones <davej@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org
In-Reply-To: <20080622090906.GD27069@cs181133002.pp.htv.fi>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	 <Jn7irxIunJK.A.nME.ZJDVIB@albercik>
	 <20080622090906.GD27069@cs181133002.pp.htv.fi>
Content-Type: text/plain
Organization: Red Hat, Inc.
Date: Mon, 23 Jun 2008 09:40:39 -0500
Message-Id: <1214232039.3724.66.camel@technetium.msp.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-5.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-06-22 at 12:09 +0300, Adrian Bunk wrote:
> On Sat, Jun 14, 2008 at 10:12:03PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10827
> > Subject		: 2.6.26rc4 GFS2 oops.
> > Submitter	: Dave Jones <davej@redhat.com>
> > Date		: 2008-05-27 15:44 (19 days old)
> > References	: http://lkml.org/lkml/2008/5/27/297
> 
> Dave, what is the status of this bug?
> 
> It's currently listed as a 2.6.26-rc regression.
> 
> Is it actually confirmed that 2.6.25 is fine?
> 
> According to the thread of the bug report there should now be a bug 
> report in the Red Hat Bugzilla for it. Bug number?
> 
> Thanks
> Adrian

Hi,

This appears to be a known bug.  There's a Fedora bugzilla record for
it here, which contains a patch to fix the problem:

https://bugzilla.redhat.com/show_bug.cgi?id=448866

The bug does not appear to be in 2.6.25; 2.6.25 is fine afaict.

Regards,

Bob Peterson
Red Hat GFS


