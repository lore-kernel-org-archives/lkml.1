Return-Path: <linux-kernel-owner+w=401wt.eu-S1754045AbYJYXY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045AbYJYXY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 19:24:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751378AbYJYXYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 19:24:50 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:15174 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbYJYXYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 19:24:49 -0400
Date: Sat, 25 Oct 2008 16:24:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: Re: [Bug #11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
Message-Id: <20081025162412.59985815.randy.dunlap@oracle.com>
In-Reply-To: <gLTYxg3cC1.A.lVG.tL6AJB@chimera>
References: <3ZqdCuOdOqB.A.EPE.fJ6AJB@chimera>
	<gLTYxg3cC1.A.lVG.tL6AJB@chimera>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Oct 2008 23:07:47 +0200 (CEST) Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).

Yes, it should still be listed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
> Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
> Submitter	: rdunlap <randy.dunlap@oracle.com>
> Date		: 2008-08-21 5:52 (66 days old)
> References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
> 		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
> Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
> 		  James Bottomley <James.Bottomley@hansenpartnership.com>

---
~Randy
