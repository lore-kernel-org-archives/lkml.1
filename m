Return-Path: <linux-kernel-owner+w=401wt.eu-S1752997AbYAHWMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997AbYAHWMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 17:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbYAHWMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 17:12:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYAHWML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 17:12:11 -0500
Date: Tue, 8 Jan 2008 23:11:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Bligh <mbligh@mbligh.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: change SCSI owner in bugzilla
Message-ID: <20080108221136.GA21482@elte.hu>
References: <20080106161635.GL2082@does.not.exist> <20080108160607.GA32273@elte.hu> <200801081849.06846.rjw@sisk.pl> <200801081851.55387.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801081851.55387.rjw@sisk.pl>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > >   Edit / Prefs / Email Preferences / Users to watch
> > > 
> > > add power-management_other@kernel-bugs.osdl.org to that list and you'll 
> > > be notified about new bugs and changes to existing bugs.
> > 
> > Still, I'd like the list to be notified, not only me (eg. I might be 
> > offline or or unable to respond at the moment, or someone else may 
> > know how to fix the problem).
> 
> Ah, you mean I should create a bugzilla user for the list and add 
> power-management_other@kernel-bugs.osdl.org to this user's watchlist.  
> That will make sense. :-)

yep, and this way the special users have consistent layout as well. I 
suspect the SCSI thing should be done this way as well. Martin, do you 
agree with that, or is there some other issue?

	Ingo
