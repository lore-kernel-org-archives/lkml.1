Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYHCExV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYHCExV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 00:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbYHCExJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 00:53:09 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59327 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbYHCExH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 00:53:07 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik>
	<5ZeQ4vXWqRC.A.NTE.bNLlIB@albercik>
Date: Sat, 02 Aug 2008 21:47:23 -0700
In-Reply-To: <5ZeQ4vXWqRC.A.NTE.bNLlIB@albercik> (Rafael J. Wysocki's message
	of "Sat, 2 Aug 2008 20:04:19 +0200 (CEST)")
Message-ID: <m1tze2aen8.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ****;"Rafael J. Wysocki" <rjw@sisk.pl>
X-Spam-Relay-Country: 
X-Spam-Report: *  7.0 XM_URI_RBL URI's domain appears in surbl.xmission.com
	*      [URIs: marc.info]
	* -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0429]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Bug #11201] kernel BUG at arch/x86/kernel/io_apic_64.c:357!
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Rafael J. Wysocki" <rjw@sisk.pl> writes:

> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed
> and let me know (either way).

Yes it should still be listed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11201
> Subject		: kernel BUG at arch/x86/kernel/io_apic_64.c:357!
> Submitter	: Dhaval Giani <dhaval@linux.vnet.ibm.com>
> Date		: 2008-07-29 16:21 (5 days old)
> References	: http://marc.info/?l=linux-kernel&m=121734804508255&w=4
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>
> 		  Eric W. Biederman <ebiederm@xmission.com>
> Patch		: http://marc.info/?l=linux-kernel&m=121735924628623&w=4
