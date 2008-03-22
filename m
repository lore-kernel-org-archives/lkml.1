Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYCVLMY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYCVLMY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 07:12:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbYCVLMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 07:12:14 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33395 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753415AbYCVLMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 07:12:13 -0400
Date: Sat, 22 Mar 2008 12:11:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux IDE mailing list <linux-ide@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Su, Henry" <Henry.Su@amd.com>, "Cai, Crane" <Crane.Cai@amd.com>,
       Shane Huang <Shane.Huang@amd.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.25-rc6-git6: Reported regressions from 2.6.24
Message-ID: <20080322111144.GB13264@elte.hu>
References: <200803220259.48534.rjw@sisk.pl> <47E4745D.3090902@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47E4745D.3090902@garzik.org>
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


* Jeff Garzik <jeff@garzik.org> wrote:

>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=9412
>> Subject		: Since commit 'x86: enable iommu_merge by default' (948062683004d13ca21c8c05ac052d387978a449) 2.6 is no go on SB600 AHCI
>> Submitter	: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
>> Date		: 2007-11-19 14:43 (124 days old)
>
> This one seems to imply that the workaround approved by AMD/ATI didn't 
> work...
>
> (AMD folks CC'd...)

note, the 'Subject' is wrong, we resolved the original regression on 
2007-11-26, 7 days after it was reported. This is about a bug with 
similar symptoms, reopened 10 days ago. Jeff, could you please change 
the bugzilla entry so that it reflects that it's an SB600 problem?

	Ingo
