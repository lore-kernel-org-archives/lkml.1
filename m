Return-Path: <linux-kernel-owner+w=401wt.eu-S1758213AbYILWPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758213AbYILWPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756247AbYILWP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:15:26 -0400
Received: from tundra.namei.org ([65.99.196.166]:54427 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755495AbYILWPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:15:25 -0400
Date: Sat, 13 Sep 2008 08:14:10 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [Bug #11500] /proc/net bug related to selinux
In-Reply-To: <SpS7rta8n4.A.i9G.ZcsyIB@albercik>
Message-ID: <alpine.LRH.1.10.0809130812460.12313@tundra.namei.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik> <SpS7rta8n4.A.i9G.ZcsyIB@albercik>
User-Agent: Alpine 1.10 (LRH 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Sep 2008, Rafael J. Wysocki wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11500
> Subject		: /proc/net bug related to selinux
> Submitter	: Andrew Morton <akpm@linux-foundation.org>
> Date		: 2008-09-04 17:45 (9 days old)
> References	: http://marc.info/?l=linux-kernel&m=122055041313270&w=4

I think this might be a regression caused by namespace changes which we 
addressed in SELinux policy.  Which distro version & policy version is 
this seen with?


- James
-- 
James Morris
<jmorris@namei.org>
