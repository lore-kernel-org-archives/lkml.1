Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbYDIHrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbYDIHrm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 03:47:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbYDIHre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 03:47:34 -0400
Received: from E23SMTP02.au.ibm.com ([202.81.18.163]:60718 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbYDIHrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 03:47:33 -0400
Message-ID: <47FC7440.8070207@linux.vnet.ibm.com>
Date: Wed, 09 Apr 2008 13:16:08 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Nish Aravamudan <nish.aravamudan@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [Bug #10082] 2.6.25-rc2-git4 - Kernel oops while running kernbench
 and tbench on powerpc
References: <SvnMeM-aZi.A.E8F.BCA_HB@albercik> <29495f1d0804090007u17b0524cwe154434d62531083@mail.gmail.com>
In-Reply-To: <29495f1d0804090007u17b0524cwe154434d62531083@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nish Aravamudan wrote:
> On 4/8/08, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> This message has been generated automatically as a part of a report
>>  of recent regressions.
>>
>>  The following bug entry is on the current list of known regressions
>>  from 2.6.24.  Please verify if it still should be listed.
> 
> From a separate thread and my own discussions with Kamalesh, I believe
> this is not actually a regression in 2.6.25-rc*, as some 2.6.24-rc
> kernel displayed the same problem. Unfortunately, it's a little tough
> to automatically bisect as the oops happens intermittently. In the
> other thread, though, Paul mentioned a patch which might fix the issue
> was merged recently.
> 
> Kamalesh, any updates?

Hi Nish,

I tested the 2.6.25-rc8 kernel which already has the patch in it, but still the oops is reproducible.
The oops was reproducible in the second run though.

> 
>>  Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10082
>>  Subject         : 2.6.25-rc2-git4 - Kernel oops while running kernbench and tbench on powerpc
>>  Submitter       : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
>>  Date            : 2008-02-20 16:01 (49 days old)
>>  References      : http://lkml.org/lkml/2008/2/20/218
>>                   http://lkml.org/lkml/2008/1/18/71
>>  Handled-By      : Paul Mackerras <paulus@samba.org>
> 
> Thanks,
> Nish


-- 
Thanks & Regards,
Kamalesh Babulal,
Linux Technology Center,
IBM, ISTL.
