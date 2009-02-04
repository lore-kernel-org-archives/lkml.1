Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbZBDQux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbZBDQux (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 11:50:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbZBDQul
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 11:50:41 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:25723 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757712AbZBDQuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 11:50:40 -0500
Message-ID: <4989C74A.2020402@oracle.com>
Date: Wed, 04 Feb 2009 08:50:18 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #12616] boot hang: async vs. kexec
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.xUD.kuYiJB@chimera>
In-Reply-To: <pWZw1SZjMCH.A.xUD.kuYiJB@chimera>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt702.oracle.com [141.146.40.80]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4989C749.01D7:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.28.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12616
> Subject		: boot hang: async vs. kexec
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2009-01-29 13:15 (7 days old)
> References	: http://lkml.org/lkml/2009/1/29/359

Please reject this for now.  I'll keep debugging/working on it
and see if any fixes are needed.

Thanks,
-- 
~Randy
