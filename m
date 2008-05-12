Return-Path: <linux-kernel-owner+w=401wt.eu-S1758671AbYELTbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758671AbYELTbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 15:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753455AbYELTbD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 15:31:03 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40913 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660AbYELTbB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 15:31:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Bug #10673] build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
Date: Mon, 12 May 2008 21:31:21 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>,
       WANG Cong <xiyou.wangcong@gmail.com>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.5QG.ev1JIB@chimera> <alpine.LFD.1.10.0805121147360.3514@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805121147360.3514@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805122131.21981.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 12 of May 2008, Thomas Gleixner wrote:
> 
> On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.25.  Please verify if it still should be listed.
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10673
> > Subject		: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
> > Submitter	: Toralf Förster <toralf.foerster@gmx.de>
> > Date		: 2008-05-09 9:13 (3 days old)
> > References	: http://marc.info/?l=linux-kernel&amp;m=121032450804476&amp;w=4
> > Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 		  Ingo Molnar <mingo@elte.hu>
> > 		  WANG Cong <xiyou.wangcong@gmail.com>
> > Patch		: http://marc.info/?l=linux-kernel&amp;m=121042819904974&amp;w=4
> 
> Duplicate of #10495

Already marked as a duplicate.

Thanks,
Rafael
