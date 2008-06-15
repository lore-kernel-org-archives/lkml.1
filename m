Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbYFOQgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbYFOQgU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 12:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758379AbYFOQgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 12:36:10 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:61184 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758356AbYFOQgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 12:36:09 -0400
Date: Sun, 15 Jun 2008 09:35:43 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: [Bug 10872] x86_64 boot hang when CONFIG_NUMA=n
Message-Id: <20080615093543.1b18b9eb.randy.dunlap@oracle.com>
In-Reply-To: <Jn7irxIunJK.A.8UD.1IDVIB@albercik>
References: <RzbtSgMztjP.A.R0C.dIDVIB@albercik>
	<Jn7irxIunJK.A.8UD.1IDVIB@albercik>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
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

On Sat, 14 Jun 2008 22:12:04 +0200 (CEST) Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10872
> Subject		: x86_64 boot hang when CONFIG_NUMA=n
> Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> Date		: 2008-06-05 21:50 (10 days old)
> References	: http://marc.info/?l=linux-kernel&m=121270308607116&w=4
> 		  http://lkml.org/lkml/2008/6/11/355
> Handled-By	: Yinghai Lu <yhlu.kernel@gmail.com>

Yes, still happens for me on 2.6.26-rc6-git2.


---
~Randy
'"Daemon' is an old piece of jargon from the UNIX operating system,
where it referred to a piece of low-level utility software, a
fundamental part of the operating system."
