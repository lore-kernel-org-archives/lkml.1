Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbZKRLJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbZKRLJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 06:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbZKRLJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 06:09:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49192 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbZKRLJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 06:09:46 -0500
Subject: Re: [Bug #14383] hackbench regression with kernel 2.6.32-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <xXQGFmujPl.A.65H.2TdALB@chimera>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.65H.2TdALB@chimera>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Nov 2009 12:09:41 +0100
Message-ID: <1258542581.3918.255.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-16 at 23:37 +0100, Rafael J. Wysocki wrote:

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14383
> Subject		: hackbench regression with kernel 2.6.32-rc1
> Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date		: 2009-10-09 9:19 (39 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=29cd8bae396583a2ee9a3340db8c5102acf9f6fd
> References	: http://marc.info/?l=linux-kernel&m=125508007510274&w=4
> Handled-By	: Peter Zijlstra <a.p.zijlstra@chello.nl>


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14384
> Subject         : tbench regression with 2.6.32-rc1
> Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date            : 2009-10-09 9:51 (39 days old)
> First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=59abf02644c45f1591e1374ee7bb45dc757fcb88
> References      : http://marc.info/?l=linux-kernel&m=125508216713138&w=4
> Handled-By      : Peter Zijlstra <a.p.zijlstra@chello.nl>



> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=14621
> Subject         : specjbb2005 and aim7 regression with 2.6.32-rc kernels
> Submitter       : Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Date            : 2009-11-06 7:38 (11 days old)
> References      : http://marc.info/?l=linux-kernel&m=125749310413174&w=4


Yanmin, could you please update me on the status of these regressions?

Mike seems to have done a lot to address issues while I was out, and
while I (hopefully) did read all resulting email, I must admit to
loosing track of where we stand.



