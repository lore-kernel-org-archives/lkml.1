Return-Path: <linux-kernel-owner+w=401wt.eu-S1753600AbYGEWPy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600AbYGEWPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 18:15:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbYGEWPq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 18:15:46 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:48051 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbYGEWPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 18:15:46 -0400
Date: Sat, 5 Jul 2008 13:51:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [Bug #10872] x86_64 boot hang when CONFIG_NUMA=n
Message-Id: <20080705135136.44f594ea.randy.dunlap@oracle.com>
In-Reply-To: <X8mbwW6K81I.A.j4E.079ZIB@albercik>
References: <q5WW6DLC10O.A.dxC.R69ZIB@albercik>
	<X8mbwW6K81I.A.j4E.079ZIB@albercik>
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

On Sun, 29 Jun 2008 20:18:43 +0200 (CEST) Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.

Yes, boot still hangs in 2.6.26-rc8-git4 when CONFIG_NUMA=n.
CONFIG_NUMA=y boots OK.

> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
> Subject		: x86_64 boot hang when CONFIG_NUMA=n
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-06-05 21:50 (25 days old)
> References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
> 		  http://lkml.org/lkml/2008/6/11/355
> 		  http://lkml.org/lkml/2008/6/15/117
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
