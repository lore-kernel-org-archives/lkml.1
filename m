Return-Path: <linux-kernel-owner+w=401wt.eu-S932419AbXC1PpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419AbXC1PpI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 11:45:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932425AbXC1PpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 11:45:07 -0400
Received: from bay0-omc1-s8.bay0.hotmail.com ([65.54.246.80]:26856 "EHLO
	bay0-omc1-s8.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932419AbXC1PpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 11:45:06 -0400
Message-ID: <BAY103-DAV235C909FDAB6433264E78B26D0@phx.gbl>
X-Originating-IP: [85.36.106.214]
X-Originating-Email: [pupilla@hotmail.com]
From: "Marco Berizzi" <pupilla@hotmail.com>
To: "Lee Revell" <rlrevell@joe-job.com>
Cc: <linux-kernel@vger.kernel.org>
References: <BAY103-DAV13FD7B01A80319110AFA3BB26D0@phx.gbl> <75b66ecd0703280839h12cfce34v39b04dfd254cc020@mail.gmail.com>
Subject: Re: oracle sqlplus loop on 2.6.20
Date: Wed, 28 Mar 2007 17:44:29 +0200
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1123
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1123
X-OriginalArrivalTime: 28 Mar 2007 15:45:04.0572 (UTC) FILETIME=[0DC587C0:01C77150]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Revell wrote:

> On 3/28/07, Marco Berizzi <pupilla@hotmail.com> wrote:
> > Hello everybody.
> > I'm running oracle 10.2.0.1 on Slackware Linux 10.2
> > After 50 days uptime, sqlplus was looping forever.
> > I have killed all oracle processes and cleared all
> > semaphore and shared memory segment with ipcrm.
> > I have also unmounted & remounted the file system
> > where the oracle binaries and library resides,
> > but no luck. I have to do a shutdown.
> > This is the output from 'strace sqlplus'.
> > Any hint?
>
> Why do you think it's a kernel issue?  Sounds like an Oracle bug to
me...

indeed. I'm becoming very small small small...
Sorry for the spam.
JFYI: there is bug in oracle when the machine
reaches 248 days uptime. (doc id 338461.1)
Sorry again.


