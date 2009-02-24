Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZBXH3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZBXH3b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 02:29:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752203AbZBXH3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 02:29:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43755 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752175AbZBXH3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 02:29:22 -0500
Date: Tue, 24 Feb 2009 08:29:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [Bug #12660] Linux 2.6.28.3 freezing on a 32-bits x86 Thinkpad
	T43p
Message-ID: <20090224072902.GA20098@elte.hu>
References: <GVhknozYwrL.A.hiC.rozoJB@chimera> <vP9hdyF4fL.A.IkE.cpzoJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vP9hdyF4fL.A.IkE.cpzoJB@chimera>
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

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12660
> Subject		: Linux 2.6.28.3 freezing on a 32-bits x86 Thinkpad T43p
> Submitter	: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Date		: 2009-02-04 21:11 (20 days old)
> References	: http://marc.info/?l=linux-kernel&m=123378196022258&w=4
> Handled-By	: Ingo Molnar <mingo@elte.hu>

Mathieu, this bug is very weird and makes little sense. Could 
you please reproduce it with vanilla -git too (without any LTT 
patches applied) and send the full boot+crash log?

	Ingo
