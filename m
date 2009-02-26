Return-Path: <linux-kernel-owner+w=401wt.eu-S1753835AbZBZSkm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbZBZSkm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 13:40:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752032AbZBZSkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 13:40:33 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48694 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbZBZSkc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 13:40:32 -0500
Date: Thu, 26 Feb 2009 19:40:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <johnstul@us.ibm.com>
Cc: hpa@zytor.com, mingo@redhat.com, williams@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [tip:timers/ntp] time: apply NTP frequency/tick changes
	immediately, fix
Message-ID: <20090226184021.GA31413@elte.hu>
References: <tip-a66a97da747f7a119f45626c9d8170f8cac61b37@kernel.org> <1235671685.3793.31.camel@jstultz-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1235671685.3793.31.camel@jstultz-laptop>
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


* John Stultz <johnstul@us.ibm.com> wrote:

> On Thu, 2009-02-26 at 17:57 +0000, John Stultz wrote:
> > Author:     John Stultz <johnstul@us.ibm.com>
> > AuthorDate: Thu, 26 Feb 2009 09:46:14 -0800
> > Commit:     Ingo Molnar <mingo@elte.hu>
> > CommitDate: Thu, 26 Feb 2009 18:55:36 +0100
> > 
> > time: apply NTP frequency/tick changes immediately, fix
> 
> Sorry, the commit name isn't quite right there. I should have added the
> patch name explicitly. This patch was a fix to the following patch in
> -tip:
> 
> time: ntp: fix bug in ntp_update_offset() & do_adjtimex()

ok, i fixed the title - thanks!

	Ingo
