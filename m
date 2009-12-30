Return-Path: <linux-kernel-owner+w=401wt.eu-S1751837AbZL3BHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbZL3BHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 20:07:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751577AbZL3BHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 20:07:14 -0500
Received: from mailget.neusoft.com ([210.83.25.69]:16405 "EHLO
	mailgate.neusoft.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbZL3BHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 20:07:13 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5846"; a="6702054"
Date: Wed, 30 Dec 2009 09:09:13 +0800 (CST)
From: fengxiangjun <fengxiangjun@neusoft.com>
Subject: Re: [Bug #14944] 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
In-reply-to: <NJVdobuNFNK.A.aBG.AnhOLB@chimera>
X-X-Sender: fengxj@darkstar.example.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>
Message-id: <alpine.LNX.2.00.0912300907110.9328@darkstar.example.net>
MIME-version: 1.0
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
References: <LptzGUUXbTK.A.MSF.ymhOLB@chimera>
 <NJVdobuNFNK.A.aBG.AnhOLB@chimera>
Content-Transfer-Encoding: 7bit
Content-Type: TEXT/PLAIN; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

The problem has been fixed by Tejun's patch,

Thanks.

On Tue, 29 Dec 2009, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.32.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=14944
> Subject		: 2.6.32.2 SATA link detect failed, 2.6.32.1 works fine
> Submitter	: fengxiangjun <fengxiangjun@neusoft.com>
> Date		: 2009-12-21 11:12 (9 days old)
> References	: http://marc.info/?l=linux-kernel&m=126139442328314&w=4
> Handled-By	: Tejun Heo <tj@kernel.org>
> Patch		: http://patchwork.kernel.org/patch/69746/
> 
> 
> 
---------------------------------------------------------------------------------------------------
Confidentiality Notice: The information contained in this e-mail and any accompanying attachment(s) 
is intended only for the use of the intended recipient and may be confidential and/or privileged of 
Neusoft Corporation, its subsidiaries and/or its affiliates. If any reader of this communication is 
not the intended recipient, unauthorized use, forwarding, printing,  storing, disclosure or copying 
is strictly prohibited, and may be unlawful.If you have received this communication in error,please 
immediately notify the sender by return e-mail, and delete the original message and all copies from 
your system. Thank you. 
---------------------------------------------------------------------------------------------------

