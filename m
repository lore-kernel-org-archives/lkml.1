Return-Path: <linux-kernel-owner+w=401wt.eu-S1760797AbYELHSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760797AbYELHSe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 03:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760367AbYELHSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 03:18:16 -0400
Received: from www.tglx.de ([62.245.132.106]:49334 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760248AbYELHSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 03:18:13 -0400
Date: Mon, 12 May 2008 09:17:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       =?ISO-8859-15?Q?Simon_Holm_Th=F8gersen?= <odie@cs.aau.dk>
Subject: Re: [Bug #10631] Please revert 709f744 (x86: bitops asm constraint
 fixes)
In-Reply-To: <88YBFoyd1CN.A.8_H.Xw1JIB@chimera>
Message-ID: <alpine.LFD.1.10.0805120916510.3514@apollo.tec.linutronix.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.8_H.Xw1JIB@chimera>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-874294452-1210576643=:3514"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-874294452-1210576643=:3514
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT

On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10631
> Subject		: Please revert 709f744 (x86: bitops asm constraint fixes)
> Submitter	: Simon Holm Thøgersen <odie@cs.aau.dk>
> Date		: 2005-05-05 09:35 (1103 days old)
> References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1963.html
> Handled-By	: Ingo Molnar <mingo@elte.hu>
> 		  Jan Beulich <jbeulich@novell.com>
> 		  Thomas Gleixner <tglx@linutronix.de>
> Patch		: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2661.html

fixed by: eb2b4e682a6d5b4779a7f1a6a8419982919795f6

Thanks,
	tglx
--8323328-874294452-1210576643=:3514--
