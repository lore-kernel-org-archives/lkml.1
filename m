Return-Path: <linux-kernel-owner+w=401wt.eu-S1755464Ab0AEVaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755464Ab0AEVaJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 16:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081Ab0AEVaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 16:30:07 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34188 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab0AEVaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 16:30:04 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
Subject: Re: [Bug #14893] Tasks stuck on I/O on armel with 2.6.32-rc8
Date: Tue, 5 Jan 2010 22:30:42 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <oBElxfTZdhL.A.bx.-vhOLB@chimera> <srmJ8vMxKPH.A.LFC.UwhOLB@chimera> <4B42972B.6030801@fifthhorseman.net>
In-Reply-To: <4B42972B.6030801@fifthhorseman.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201001052230.42567.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Daniel Kahn Gillmor wrote:
> Hi Rafael--
> 
> On 12/29/2009 10:28 AM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.31 and 2.6.32.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.31 and 2.6.32.  Please verify if it still should
> > be listed and let me know (either way).
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14893
> > Subject		: Tasks stuck on I/O on armel with 2.6.32-rc8
> > Submitter	: Daniel Kahn Gillmor <dkg@fifthhorseman.net>
> > Date		: 2009-11-24 23:05 (36 days old)
> > References	: http://marc.info/?l=linux-kernel&m=125910438530554&w=4
> 
> The machine in question has been up continuously (though not under heavy
> load) since it was rebooted after the reported failure.  it has even
> withstood additional mpd index updates, all running the same kernel it
> crashed with before.
> 
> So i can't say that the problem is resolved, but i haven't replicated it
> either.  Wish i had more interesting details to report.

I'm going to close it as "unreprodicible", then.  Please reopen if you're able
to reproduce it after all.

> Thanks for doing followup/triage like this.

Well, you're welcome. :-)

Rafael
