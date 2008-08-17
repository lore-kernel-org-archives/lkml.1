Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbYHQMQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbYHQMQb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbYHQMQX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:16:23 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbYHQMQW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:16:22 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11209] 2.6.27-rc1 process time accounting
Date: Sun, 17 Aug 2008 14:19:56 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.2MH.lczpIB@albercik> <1218960468.10800.257.camel@twins>
In-Reply-To: <1218960468.10800.257.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808171419.57165.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of August 2008, Peter Zijlstra wrote:
> On Sat, 2008-08-16 at 21:02 +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11209
> > Subject		: 2.6.27-rc1 process time accounting
> > Submitter	: Lukas Hejtmanek <xhejtman@ics.muni.cz>
> > Date		: 2008-07-31 10:43 (17 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
> > Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> 
> Should be fixed by: e26b33e9552c29c1d3fe67dc602c6264c29f5dc7

Thanks, closed.

Rafael
