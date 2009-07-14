Return-Path: <linux-kernel-owner+w=401wt.eu-S1756211AbZGNTem@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211AbZGNTem (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 15:34:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZGNTel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 15:34:41 -0400
Received: from fafnir.cs.unc.edu ([152.2.129.90]:51979 "EHLO fafnir.cs.unc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbZGNTek (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 15:34:40 -0400
Date: Tue, 14 Jul 2009 15:33:42 -0400 (EDT)
From: "James H. Anderson" <anderson@cs.unc.edu>
To: Henrik Austad <henrik@austad.us>
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Chris Friesen <cfriesen@nortel.com>, Raistlin <raistlin@linux.it>,
       Douglas Niehaus <niehaus@ittc.ku.edu>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Bill Huey <billh@gnuppy.monkey.org>,
       Linux RT <linux-rt-users@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Thomas Gleixner <tglx@linutronix.de>, Ted Baker <baker@cs.fsu.edu>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Noah Watkins <jayhawk@soe.ucsc.edu>,
       KUSP Google Group <kusp@googlegroups.com>,
       Tommaso Cucinotta <cucinotta@sssup.it>,
       Giuseppe Lipari <lipari@retis.sssup.it>,
       Bjoern Brandenburg <bbb@cs.unc.edu>
Subject: Re: RFC for a new Scheduling policy/class in the Linux-kernel
In-Reply-To: <200907142128.48558.henrik@austad.us>
Message-ID: <alpine.LRH.2.00.0907141531430.16818@anderson.cs.unc.edu>
References: <200907102350.47124.henrik@austad.us> <1247589099.7500.191.camel@twins> <alpine.LRH.2.00.0907141234280.16818@anderson.cs.unc.edu> <200907142128.48558.henrik@austad.us>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>> This follows from results in:
>>
>> H. Leontyev and J. Anderson, "Generalized Tardiness Bounds for Global
>> Multiprocessor Scheduling",  Proceedings of the 28th IEEE Real-Time
>> Systems Symposium, pp. 413-422, December 2007.
>
> Is this available outside locked portals?

Yes, all my stuff is freely available at:

http://www.cs.unc.edu/~anderson/papers.html

-Jim
