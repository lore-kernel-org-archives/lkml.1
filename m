Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbYKCJJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbYKCJJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 04:09:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754790AbYKCJJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 04:09:36 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37765 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777AbYKCJJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 04:09:35 -0500
Date: Mon, 3 Nov 2008 10:09:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Tomas Winkler <tomasw@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Carlos R. Mafra" <crmafra2@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [Bug #11845] Suspend regression on Lenovo x60
Message-ID: <20081103090926.GJ11730@elte.hu>
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.3LH.0keDJB@chimera> <20081102220758.GA14374@localhost.aei.mpg.de> <200811030055.22645.rjw@sisk.pl> <1ba2fa240811030104w3ebc3acfs2e1a135457a1bade@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ba2fa240811030104w3ebc3acfs2e1a135457a1bade@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tomas Winkler <tomasw@gmail.com> wrote:

> On Mon, Nov 3, 2008 at 1:55 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, 2 of November 2008, Carlos R. Mafra wrote:
> >> On Sun  2.Nov'08 at 17:07:01 +0100, Rafael J. Wysocki wrote:
> >> > This message has been generated automatically as a part of a report
> >> > of recent regressions.
> >> >
> >> > The following bug entry is on the current list of known regressions
> >> > from 2.6.27.  Please verify if it still should be listed and let me know
> >> > (either way).
> >> >
> >> >
> >> > Bug-Entry   : http://bugzilla.kernel.org/show_bug.cgi?id=11845
> >> > Subject             : Suspend regression on Lenovo x60
> >> > Submitter   : Jens Axboe <jens.axboe@oracle.com>
> >> > Date                : 2008-10-24 18:02 (10 days old)
> >> > References  : http://marc.info/?l=linux-next&m=122487159829507&w=4
> >> >               http://marc.info/?l=linux-kernel&m=122512449714310&w=4
> >> > Handled-By  : Rafael J. Wysocki <rjw@sisk.pl>
> >> >               Tomas Winkler <tomasw@gmail.com>
> >> > Patch               : http://marc.info/?l=linux-kernel&m=122513311900482&w=4
> >> >               http://marc.info/?l=linux-wireless&m=122518625308673&w=4
> >>
> >> It is fixed by commit 10d0bd56966571d0324dfd9bbb8aa913a60bef5f which
> >> is now in Linus' tree.
> >
> > Thanks, closed.
> 
> Is this queued  also for 2.6.27 stable ? My email was bounced back
> I've used linux-stable@veger.kernel.org

three typos caused thebounce. It's stable@kernel.org.

	Ingo
