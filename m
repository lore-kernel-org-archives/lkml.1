Return-Path: <linux-kernel-owner+w=401wt.eu-S1755827AbZG1WXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827AbZG1WXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZG1WXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:23:17 -0400
Received: from 216-235-106-HCC-115.hcc.net ([216.235.106.115]:48857 "EHLO
	mail.howardsilvan.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbZG1WXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:23:16 -0400
Message-ID: <4A6F7A51.8070601@howardsilvan.com>
Date: Tue, 28 Jul 2009 15:23:13 -0700
From: Lee Howard <faxguy@howardsilvan.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: linux-kernel@vger.kernel.org
Subject: Re: [Fwd: how to debug: BUG: soft lockup - CPU#3 stuck for 61s!]
References: <4A6F67E3.60201@howardsilvan.com> <200907282330.53059.rjw@sisk.pl>
In-Reply-To: <200907282330.53059.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Tuesday 28 July 2009, Lee Howard wrote:
>   
>> I installed Fedora 11 and I'm getting the same thing there, too (kernel
>> 2.6.29.6-213.fc11.x86_64).
>>
>> What can I do to help fix this?
>>     
>
> Please test the last 2.6.30.y from kernel.org.  If the bug is still there, test
> 2.6.31-rc4 or later.  If the bug is still there, please report it here or at
> bugzilla.kernel.org.
>
> If the bug is not present in 2.6.30.y, try to find the commit that fixed it
> (using git-bisect, but marking good commits as 'bad' and bad commits as 'good')
> and point the Fedora kernel maintainer(s) to it.  Same for 2.6.31-rc4 or later.

Thank you for your reply.  I have now installed kernel 
2.6.31-0.94.rc4.fc12.x86_64 from Fedora development.  If the problem 
continues I will report it.

Thanks,

Lee.
