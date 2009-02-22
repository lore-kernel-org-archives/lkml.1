Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZBVCrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZBVCrc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 21:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754562AbZBVCrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 21:47:24 -0500
Received: from vms173007pub.verizon.net ([206.46.173.7]:63141 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990AbZBVCrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 21:47:23 -0500
Date: Sat, 21 Feb 2009 21:47:11 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>, Arjan van de Ven <arjan@linux.intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Weiner <hannes@cmpxchg.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Andrey Borzenkov <arvidjaar@mail.ru>
Subject: Re: [PATCH 0/9] PM: Fixes related to suspend and hibernation for 2.6.29
In-reply-to: <alpine.LFD.2.00.0902211417401.3111@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0902212145050.5009@localhost.localdomain>
References: <200902140157.40869.rjw@sisk.pl>
 <alpine.LFD.2.00.0902202337040.19156@localhost.localdomain>
 <200902211038.42169.rjw@sisk.pl> <20090221182902.GB12472@suse.de>
 <49A056D5.5090909@linux.intel.com> <20090221194807.GA13114@suse.de>
 <alpine.LFD.2.00.0902211417401.3111@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I took them all, and added both of you to the cc, so if/when things break 
> and get bisected to this series, both of you should be cc'd on the 
> discussion.

Okay, I'll delete them from my suspend branch.

thanks,
-Len

