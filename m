Return-Path: <linux-kernel-owner+w=401wt.eu-S1752010AbYAHKI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbYAHKI3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 05:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYAHKIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 05:08:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:38105 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbYAHKIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 05:08:16 -0500
Date: Tue, 8 Jan 2008 11:07:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Martin Bligh <mbligh@mbligh.org>, Adrian Bunk <bunk@stusta.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@ftp.linux.org.uk>, bugme-admin@linux-foundation.org,
       Peter Osterlund <petero2@telia.com>
Subject: Re: change SCSI owner in bugzilla
Message-ID: <20080108100752.GA6906@elte.hu>
References: <20080106161635.GL2082@does.not.exist> <47828CC7.7060106@mbligh.org> <200801072147.53011.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200801072147.53011.rjw@sisk.pl>
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

> > OK, changed it.
> > 
> > I don't think this is the right way to do it, as you'll get email 
> > for every change to every bug until it's assigned, but seeing as 
> > that's what you asked for, and we can't seem to get vger to take 
> > bounces, I guess it'll do.
> > 
> > Let me know if (a) it works OK, and (b) you want the driver ones 
> > changed over as well.
> 
> BTW, would that be possible to forward messages sent to
> power-management_other@kernel-bugs.osdl.org to
> linux-pm@lists.linux-foundation.org?

stupid question: why isnt this done via what most maintainers do, to set 
up your bugzilla account to generate notifications of the special 
power-management_other@kernel-bugs.osdl.org bugzilla user?

	Ingo
