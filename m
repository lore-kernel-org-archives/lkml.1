Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbYIGV5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbYIGV5x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 17:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYIGV5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 17:57:45 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41251 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752798AbYIGV5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 17:57:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [Bug #11209] 2.6.27-rc1 process time accounting
Date: Mon, 8 Sep 2008 00:02:08 +0200
User-Agent: KMail/1.9.9
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
References: <s3QDdfEDq6.A.wlH.MowwIB@albercik> <Wz8EH5sroeE.A.mUD.WswwIB@albercik> <1220778273.8687.20.camel@twins.programming.kicks-ass.net>
In-Reply-To: <1220778273.8687.20.camel@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809080002.09381.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 7 of September 2008, Peter Zijlstra wrote:
> On Sat, 2008-09-06 at 23:30 +0200, Rafael J. Wysocki wrote:
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
> > Date		: 2008-07-31 10:43 (38 days old)
> > References	: http://marc.info/?l=linux-kernel&m=121750102917490&w=4
> > Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>
> 
> Should be fixed in the latest -git

Thanks for the update.

Does any specific commit fix it or just a series of recent commits?

Rafael
