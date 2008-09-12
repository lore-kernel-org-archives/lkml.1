Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbYILWZy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbYILWZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:25:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757695AbYILWZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:25:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758202AbYILWZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:25:41 -0400
Date: Fri, 12 Sep 2008 15:24:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: James Morris <jmorris@namei.org>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       sds@tycho.nsa.gov
Subject: Re: [Bug #11500] /proc/net bug related to selinux
Message-Id: <20080912152443.c4e59f42.akpm@linux-foundation.org>
In-Reply-To: <alpine.LRH.1.10.0809130812460.12313@tundra.namei.org>
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	<SpS7rta8n4.A.i9G.ZcsyIB@albercik>
	<alpine.LRH.1.10.0809130812460.12313@tundra.namei.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Sep 2008 08:14:10 +1000 (EST)
James Morris <jmorris@namei.org> wrote:

> On Fri, 12 Sep 2008, Rafael J. Wysocki wrote:
> 
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11500
> > Subject		: /proc/net bug related to selinux
> > Submitter	: Andrew Morton <akpm@linux-foundation.org>
> > Date		: 2008-09-04 17:45 (9 days old)
> > References	: http://marc.info/?l=linux-kernel&m=122055041313270&w=4
> 
> I think this might be a regression caused by namespace changes which we 
> addressed in SELinux policy.  Which distro version & policy version is 
> this seen with?
> 

FC5 on x86_32 and FC6 on x86_64.
