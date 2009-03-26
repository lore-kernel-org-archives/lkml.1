Return-Path: <linux-kernel-owner+w=401wt.eu-S1760490AbZCZWc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490AbZCZWc2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 18:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZCZWcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 18:32:19 -0400
Received: from col0-omc4-s2.col0.hotmail.com ([65.55.34.204]:22050 "EHLO
	col0-omc4-s2.col0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752414AbZCZWcT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 18:32:19 -0400
Message-ID: <COL112-W1F128D0A25E4992851102C8910@phx.gbl>
X-Originating-IP: [76.197.186.32]
From: Adam Turk <bofh1234@hotmail.com>
To: <leon.woestenberg@gmail.com>
CC: <linux-kernel@vger.kernel.org>
Subject: RE: recommended programming practices for writing (was Linux 2.6.29)
Date: Thu, 26 Mar 2009 18:32:17 -0400
Importance: Normal
In-Reply-To: <c384c5ea0903261235sf1a4440q6fb5f38c983770bc@mail.gmail.com>
References: <COL112-W81AF4A8C222B9941D8295FC8910@phx.gbl>
 <c384c5ea0903261235sf1a4440q6fb5f38c983770bc@mail.gmail.com>
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 26 Mar 2009 22:32:17.0738 (UTC) FILETIME=[B8368AA0:01C9AE62]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On Thu, Mar 26, 2009 at 8:03 PM, Adam Turk  wrote:
>>
>> I have been reading the Linux 2.6.29 thread with interest.  I have written several (10 or so) C programs that write large amounts of data (between 1 and 2 GB file sizes are common).  A snippet of code looks like this:
>>
>> I learned C about 15 years ago and there was no mention of a fsync.  My C book doesn't mention fsync either.  Granted I have written only 25-30 applications in the last 15 years or so so I am not an expert C programmer.
>>
>
> Your question is really off-topic for the Linux Kernel mailing list,
> but let me point you somewhere else:
>
> There is (1) the C library and (2) the functions provided by your
> operating system. Linux follows to some extend the POSIX functions for
> (2).
>
> A good read is the book "Linux Systems Programming" if you want to go
> beyond what the C library offers, for starters.
>

I don't think it is really off topic as in the original topic thread there were comments about lazy programmers who didn't write their code properly.  Noone who made those comments gave examples of bad and good code so I decided to ask.  

Thank you for the recommendation.  I will check the local bookstores.

Thanks,
Adam

_________________________________________________________________
Windows Live™ SkyDrive: Get 25 GB of free online storage.
http://windowslive.com/online/skydrive?ocid=TXT_TAGLM_WL_skydrive_032009