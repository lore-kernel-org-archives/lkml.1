Return-Path: <linux-kernel-owner+w=401wt.eu-S1755683AbZBXA75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683AbZBXA75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 19:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbZBXA7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 19:59:48 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:37504 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZBXA7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 19:59:47 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <LLno3yT_fnC.A.-RH.ZzzoJB@chimera>
References: <HFSEX4uppGO.A.JSG.2yzoJB@chimera>
	 <LLno3yT_fnC.A.-RH.ZzzoJB@chimera>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Tue, 24 Feb 2009 11:29:43 +1030
Message-Id: <1235437183.4988.2.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-23 at 23:03 +0100, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.27 and 2.6.28.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).

Yes, the problem should still be listed.
The bug is still present as recently as 2.6.29-rc5-00299-gadfafef.

Regards,
Kevin.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
> Subject		: KVM guests stalling on 2.6.28 (bisected)
> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
> Date		: 2009-01-17 03:37 (38 days old)


