Return-Path: <linux-kernel-owner+w=401wt.eu-S1761298AbYILVAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761298AbYILVAy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 17:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758801AbYILUrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 16:47:22 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:45107 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572AbYILUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 16:47:20 -0400
Message-ID: <48CAD51D.4060908@oracle.com>
Date: Fri, 12 Sep 2008 13:46:21 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug #11276] build error: CONFIG_OPTIMIZE_INLINING=y causes gcc
 4.2 to do stupid things
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.W3.8esyIB@albercik>
In-Reply-To: <SpS7rta8n4.A.W3.8esyIB@albercik>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11276
> Subject		: build error: CONFIG_OPTIMIZE_INLINING=y causes gcc 4.2 to do stupid things
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-08-06 17:18 (38 days old)
> References	: http://marc.info/?l=linux-kernel&m=121804329014332&w=4
> 		  http://lkml.org/lkml/2008/7/22/353
> Handled-By	: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Patch		: http://lkml.org/lkml/2008/7/22/364

Yes, I still see this build error.
What would it take to have Bjorn's patch merged into mainline?

-- 
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
