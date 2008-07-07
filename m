Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYGGQQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYGGQQf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbYGGQQZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:16:25 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40889 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753439AbYGGQQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:16:24 -0400
Date: Mon, 7 Jul 2008 17:16:21 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Dan Williams <dan.j.williams@intel.com>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [Bug #11025] [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
Message-ID: <20080707161620.GA30381@csn.ul.ie>
References: <Vu1KV8Wj_GP.A.qW.DzLcIB@albercik> <uBi7uNfg81L.A.z4.WzLcIB@albercik>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <uBi7uNfg81L.A.z4.WzLcIB@albercik>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/07/08 13:45), Rafael J. Wysocki didst pronounce:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11025
> Subject		: [problem] raid performance loss with 2.6.26-rc8 on 32-bit x86 (bisected)
> Submitter	: Dan Williams <dan.j.williams@intel.com>
> Date		: 2008-07-01 1:57 (6 days old)
> References	: http://marc.info/?l=linux-kernel&m=121487749429883&w=4
> Handled-By	: Mel Gorman <mel@csn.ul.ie>
> 		  Andy Whitcroft <apw@shadowen.org>
> 

Fixed by commit 494de90098784b8e2797598cefdd34188884ec2e and should be
closed.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
