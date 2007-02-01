Return-Path: <linux-kernel-owner+w=401wt.eu-S1751194AbXBAP2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751194AbXBAP2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 10:28:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbXBAP2J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 10:28:09 -0500
Received: from smtpout.mac.com ([17.250.248.173]:54043 "EHLO smtpout.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbXBAP2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 10:28:08 -0500
In-Reply-To: <3d57814d0701312257x1f1fc352r6aecae72c89bee3c@mail.gmail.com>
References: <3d57814d0701312257x1f1fc352r6aecae72c89bee3c@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <CAEB951D-58D6-447D-8CDE-F1F5A1FE76C5@mac.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Mach-O loader
Date: Thu, 1 Feb 2007 10:27:59 -0500
To: Trent Waddington <trent.waddington@gmail.com>
X-Mailer: Apple Mail (2.752.2)
X-Brightmail-Tracker: AAAAAA==
X-Brightmail-scanned: yes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 01, 2007, at 01:57:53, Trent Waddington wrote:
> Anyone know if a loader for Mach-O binaries for Linux has been  
> written?

I started working on one a while ago but I ran out of time to  
dedicate to the project.  My schedule is opening up again, though, so  
I plan to start working on it again.  At this point I have most of  
the actual loader code written, the problem is that the syscalls  
between Linux and Darwin are very different and need a binary  
translation layer which is still in the concept phase at this point. :-D

Cheers,
Kyle Moffett

