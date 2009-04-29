Return-Path: <linux-kernel-owner+w=401wt.eu-S1756571AbZD2FOV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbZD2FOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 01:14:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753270AbZD2FOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 01:14:11 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:41223 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbZD2FOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 01:14:09 -0400
Message-ID: <49F7E222.4050202@in.ibm.com>
Date: Wed, 29 Apr 2009 10:44:10 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13068] Lockdep warining in inotify_dev_queue_event
References: <47KgT3nlbjD.A.lnB.jc48JB@chimera> <Fg2zLW93smL.A.XKF.4d48JB@chimera>
In-Reply-To: <Fg2zLW93smL.A.XKF.4d48JB@chimera>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
>
>
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13068
> Subject		: Lockdep warining in inotify_dev_queue_event
> Submitter	: Sachin Sant <sachinp@in.ibm.com>
> Date		: 2009-04-05 12:37 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=123893439229272&w=4
>
>
>   
I have not been able to recreate this problem with recent 
kernels(rc3-git's).

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

