Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbYJGPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbYJGPce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 11:32:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752993AbYJGPc0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 11:32:26 -0400
Received: from mx2.redhat.com ([66.187.237.31]:40444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752842AbYJGPcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 11:32:25 -0400
Date: Tue, 7 Oct 2008 11:32:03 -0400
From: Dave Jones <davej@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #11224] Only three cores found on quad-core machine.
Message-ID: <20081007153203.GB3337@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Nick Piggin <nickpiggin@yahoo.com.au>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>
References: <0pOgGB.A.uLG.E475IB@wind> <yWwteD.A.xUB.2875IB@wind> <200810080218.18898.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810080218.18898.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 02:18:18AM +1100, Nick Piggin wrote:
 > On Sunday 05 October 2008 04:32, Rafael J. Wysocki wrote:
 > > This message has been generated automatically as a part of a report
 > > of recent regressions.
 > >
 > > The following bug entry is on the current list of known regressions
 > > from 2.6.26.  Please verify if it still should be listed and let me know
 > > (either way).
 > >
 > >
 > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11224
 > > Subject		: Only three cores found on quad-core machine.
 > > Submitter	: Dave Jones <davej@redhat.com>
 > > Date		: 2008-08-01 18:15 (65 days old)
 > > References	: http://marc.info/?l=linux-kernel&m=121761475224719&w=4
 > 
 > Dave, is your CPU2 getting stuck in calibrate_delay? Can you still
 > reproduce the bug? What if you boot the kernel with lpj=<something sane
 > like 2666785> in order to skip the calibrate_delay code?
 > 
 > If that helps, can you try adding some printks to narrow down where it
 > is getting stuck?

This is going to sound strange, but I've forgotten which box that was.
I'm due to reinstall all my test boxes now that the next Fedora beta
has come out anyway, so I'll hopefully figure out by the end of the week :)

	Dave

-- 
http://www.codemonkey.org.uk
