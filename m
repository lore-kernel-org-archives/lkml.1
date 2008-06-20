Return-Path: <linux-kernel-owner+w=401wt.eu-S1752426AbYFTGBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752426AbYFTGBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 02:01:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751157AbYFTGBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 02:01:39 -0400
Received: from vms173001pub.verizon.net ([206.46.173.1]:53184 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbYFTGBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 02:01:38 -0400
Date: Fri, 20 Jun 2008 02:01:30 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
Subject: Re: Oops report for the week preceding June 16th, 2008
In-reply-to: <20080619002126.GA19724@elte.hu>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, tglx@linutronix.de, linville@tuxdriver.com,
       davej@redhat.com, gregkh@suse.de
Message-id: <alpine.LFD.1.10.0806200154300.22284@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20080617092023.GA20621@elte.hu>
 <20080617.022652.76635616.davem@davemloft.net> <20080617153356.GA3510@elte.hu>
 <20080617.145153.229833994.davem@davemloft.net>
 <20080619002126.GA19724@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> my only worry was about the current situation, which, according to 
> kerneloops.org, with 17442 oopses reported against v2.6.25, isnt 
> anything to feel too great about. (And that's not limited to wireless in 
> any way - there is a rather prominent tick_broadcast_oneshot_control() 
> soft lockup entry as well that we are trying to figure out.)
> 
> It will all get better i'm sure - we now finally have objective 
> visibility of bugs as they happen to users.

kerneloops.org is indeed a wonderful thing (kudos to Arjan, once again!).

Note, however, that the large number of recent reports isn't necessarily a 
fair comparison with numbers for previous releases.  For the number of 
clients to report to kerneloops.org is not constant.  (eg. it was included 
with Fedora Core 9, but not with Fedora Core 8)

cheers,
-Len


