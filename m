Return-Path: <linux-kernel-owner+w=401wt.eu-S1758852AbYELT0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852AbYELT0I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751660AbYELTZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:25:56 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40869 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592AbYELTZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:25:55 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10631] Please revert 709f744 (x86: bitops asm constraint fixes)
Date: Mon, 12 May 2008 21:26:08 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       Simon Holm =?iso-8859-15?q?Th=F8gersen?= <odie@cs.aau.dk>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.8_H.Xw1JIB@chimera> <alpine.LFD.1.10.0805120916510.3514@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805120916510.3514@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805122126.09399.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Thomas Gleixner wrote:
> On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10631
> > Subject		: Please revert 709f744 (x86: bitops asm constraint fixes)
> > Submitter	: Simon Holm Thøgersen <odie@cs.aau.dk>
> > Date		: 2005-05-05 09:35 (1103 days old)
> > References	: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1963.html
> > Handled-By	: Ingo Molnar <mingo@elte.hu>
> > 		  Jan Beulich <jbeulich@novell.com>
> > 		  Thomas Gleixner <tglx@linutronix.de>
> > Patch		: http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/2661.html
> 
> fixed by: eb2b4e682a6d5b4779a7f1a6a8419982919795f6

Thanks, closed.

Rafael
