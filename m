Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbYFOHuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbYFOHuh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 03:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755906AbYFOHu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 03:50:27 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60183 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755904AbYFOHu1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 03:50:27 -0400
Date: Sun, 15 Jun 2008 09:50:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: =?iso-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bug 10864] [regression][bisected] ~90,000 wakeups as of
	2.6.26-rc3
Message-ID: <20080615075008.GD29552@elte.hu>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik> <Jn7irxIunJK.A.UoD.BJDVIB@albercik> <4854B71D.9080801@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4854B71D.9080801@freemail.hu>
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


* Németh Márton <nm127@freemail.hu> wrote:

> Hi,
> 
> I already mentioned at the bug report that 2.6.26-rc6 this is fixed.
> 
> Maybe tell your robot to first check the latest activities in the bug 
> report since the last -rc release. What I want also to tell your robot 
> that it should mention what actions should be taken in case the bug 
> should be still listed or when the bug can be closed.

i think the current regression tracking methods that Rafael uses work 
very well and i'd like to thank Rafael for those efforts - to me as a 
subsystem maintainer it is a _very_ useful thing.

In this case there was no real harm from the "this bug is already fixed" 
condition - just an extra email. Real harm would only come from missed 
regressions or from incorrectly closed regressions - but those are not 
happening.

note that there is no "robot" involved in changing the state of bugs - 
the real important work here is done by Rafael and checking whether a 
bug is still relevant is an inevitably manual work. The mails and 
reports are auto-generated but crawling discussions and determining the 
status of a regression is very hard to automate.

	Ingo
