Return-Path: <linux-kernel-owner+w=401wt.eu-S1754350AbZCDDIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350AbZCDDIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 22:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZCDDIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 22:08:32 -0500
Received: from bowden.ucwb.org.au ([203.122.237.119]:47825 "EHLO
	mail.ucwb.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794AbZCDDIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 22:08:31 -0500
Subject: Re: [Bug #12465] KVM guests stalling on 2.6.28 (bisected)
From: Kevin Shanahan <kmshanah@ucwb.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <pRIaSZpQ1ON.A.vrC.udarJB@chimera>
References: <r4SCKuuJK0F.A.UrB.QdarJB@chimera>
	 <pRIaSZpQ1ON.A.vrC.udarJB@chimera>
Content-Type: text/plain
Organization: UnitingCare Wesley Bowden
Date: Wed, 04 Mar 2009 13:38:19 +1030
Message-Id: <1236136099.7726.12.camel@kulgan.wumi.org.au>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-03 at 20:41 +0100, Rafael J. Wysocki wrote:
> The following bug entry is on the current list of known regressions
> introduced between 2.6.27 and 2.6.28.  Please verify if it still should
> be listed and let me know (either way).
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12465
> Subject		: KVM guests stalling on 2.6.28 (bisected)
> Submitter	: Kevin Shanahan <kmshanah@ucwb.org.au>
> Date		: 2009-01-17 03:37 (46 days old)
> Handled-By	: Avi Kivity <avi@redhat.com>

Yes this should still be listed.

The traces are there waiting to be looked at. If there's anything else I
can do to help things along, please let me know.

Regards,
Kevin.


