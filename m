Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbYELJtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbYELJtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 05:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756303AbYELJtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 05:49:04 -0400
Received: from www.tglx.de ([62.245.132.106]:53655 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148AbYELJtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 05:49:01 -0400
Date: Mon, 12 May 2008 11:48:41 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [Bug #10673] build issue #380 for v2.6.26-rc1-279-g28a4acb :
 mach-voyager: multiple definition of `phys_cpu_present_map'
In-Reply-To: <88YBFoyd1CN.A.5QG.ev1JIB@chimera>
Message-ID: <alpine.LFD.1.10.0805121147360.3514@apollo.tec.linutronix.de>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.5QG.ev1JIB@chimera>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-155003656-1210585724=:3514"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-155003656-1210585724=:3514
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
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10673
> Subject		: build issue #380 for v2.6.26-rc1-279-g28a4acb : mach-voyager: multiple definition of `phys_cpu_present_map'
> Submitter	: Toralf Förster <toralf.foerster@gmx.de>
> Date		: 2008-05-09 9:13 (3 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121032450804476&amp;w=4
> Handled-By	: James Bottomley <James.Bottomley@HansenPartnership.com>
> 		  Ingo Molnar <mingo@elte.hu>
> 		  WANG Cong <xiyou.wangcong@gmail.com>
> Patch		: http://marc.info/?l=linux-kernel&amp;m=121042819904974&amp;w=4

Duplicate of #10495

Thanks,
	tglx
--8323328-155003656-1210585724=:3514--
