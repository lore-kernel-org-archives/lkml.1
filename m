Return-Path: <linux-kernel-owner+w=401wt.eu-S1755520AbYHQMrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbYHQMrL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 08:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753345AbYHQMq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 08:46:56 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:35215 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753111AbYHQMqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 08:46:55 -0400
Date: Sun, 17 Aug 2008 14:46:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Jean Delvare <khali@linux-fr.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [Bug #11346] kernel BUG at arch/x86/mm/pat.c:233!
Message-ID: <20080817124639.GG21434@elte.hu>
References: <DLWXHEp37wB.A.duD.yZzpIB@albercik> <sNRO-BDDjQL.A.99D.9ZzpIB@albercik> <20080816224526.43145f77@hyperion.delvare> <200808171435.57225.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808171435.57225.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Saturday, 16 of August 2008, Jean Delvare wrote:
> > Hi Rafael,
> > 
> > On Sat, 16 Aug 2008 21:02:56 +0200 (CEST), Rafael J. Wysocki wrote:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.26.  Please verify if it still should be listed and let me know
> > > (either way).
> > > 
> > > 
> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11346
> > > Subject	: kernel BUG at arch/x86/mm/pat.c:233!
> > > Submitter	: Jean Delvare <khali@linux-fr.org>
> > > Date		: 2008-08-15 02:10 (2 days old)
> > > Handled-By	: Andi Kleen <andi@firstfloor.org>
> > > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17270&action=view
> > 
> > Andi's patch still needs to be pushed to Linus.
> 
> Thanks for the update.

now upstream as commit e213e8778.

	Ingo
