Return-Path: <linux-kernel-owner+w=401wt.eu-S1757002AbZJBHCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757002AbZJBHCO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 03:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756567AbZJBHCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 03:02:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:38650 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755829AbZJBHCM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 03:02:12 -0400
Subject: Re: [Bug #14133] WARNING: at arch/x86/kernel/smp.c:117
 native_smp_send_reschedule
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
       Jens Axboe <jens.axboe@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, Gautham R Shenoy <ego@in.ibm.com>
In-Reply-To: <COE24pZSBH.A.oEC.lNTxKB@chimera>
References: <3onW63eFtRF.A.xXH.oMTxKB@chimera>
	 <COE24pZSBH.A.oEC.lNTxKB@chimera>
Content-Type: text/plain
Date: Fri, 02 Oct 2009 12:30:55 +0530
Message-Id: <1254466855.3531.6.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jens,

On Thu, 2009-10-01 at 21:55 +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.30 and 2.6.31.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.30 and 2.6.31.  Please verify if it still should
> be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14133
> Subject		: WARNING: at arch/x86/kernel/smp.c:117 native_smp_send_reschedule
> Submitter	: Jens Axboe <jens.axboe@oracle.com>
> Date		: 2009-08-31 20:43 (32 days old)
> References	: http://marc.info/?l=linux-kernel&m=125175143918050&w=4
> 
> 

Are you still getting this warning in latest -tip. If yes, can you do
git bisect and specify the commit.

Thanks,
--
JSR




