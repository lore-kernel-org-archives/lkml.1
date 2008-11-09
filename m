Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYKIWZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYKIWZg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 17:25:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYKIWZ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 17:25:27 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:56508 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921AbYKIWZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 17:25:26 -0500
Message-ID: <49176323.6080409@oracle.com>
Date: Sun, 09 Nov 2008 14:24:35 -0800
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
References: <A3oCZU7cpuO.A.ChB.ZZ1FJB@chimera> <4B0Eqx89uNG.A.ozD.vb1FJB@chimera>
In-Reply-To: <4B0Eqx89uNG.A.ozD.vb1FJB@chimera>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt705.oracle.com [141.146.40.83]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49176346.00BF:SCFSTAT928724,ss=1,fgs=0
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

Yes, it should still be listed.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11404
> Subject		: BUG: in 2.6.23-rc3-git7 in do_cciss_intr
> Submitter	: rdunlap <randy.dunlap@oracle.com>
> Date		: 2008-08-21 5:52 (81 days old)
> References	: http://marc.info/?l=linux-kernel&m=121929819616273&w=4
> 		  http://marc.info/?l=linux-kernel&m=121932889105368&w=4
> Handled-By	: Miller, Mike (OS Dev) <Mike.Miller@hp.com>
> 		  James Bottomley <James.Bottomley@hansenpartnership.com>

-- 
~Randy
