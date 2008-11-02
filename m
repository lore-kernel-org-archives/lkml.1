Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779AbYKBVnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779AbYKBVnn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 16:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754204AbYKBVnf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 16:43:35 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:51416 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754071AbYKBVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:43:34 -0500
Message-ID: <490E1EBE.3080304@oracle.com>
Date: Sun, 02 Nov 2008 13:42:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: Re: [Bug #11404] BUG: in 2.6.23-rc3-git7 in do_cciss_intr
References: <Sl8SUNhCbfL.A.O5H.yueDJB@chimera> <4xS1r6m15_B.A.ZcC.LxeDJB@chimera>
In-Reply-To: <4xS1r6m15_B.A.ZcC.LxeDJB@chimera>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Source-IP: agmgw1.us.oracle.com [152.68.180.212]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A09020A.490E1ED7.00F6:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.26 and 2.6.27.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.26 and 2.6.27.  Please verify if it still should
> be listed and let me know (either way).
> 
Yes, leave it active, please.
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
> Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
> Submitter	: rdunlap <randy.dunlap@oracle.com>
> Date		: 2008-08-21 5:52 (74 days old)
> References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
> 		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
> Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
> 		  James Bottomley <James.Bottomley@hansenpartnership.com>

-- 
~Randy
