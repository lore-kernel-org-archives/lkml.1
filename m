Return-Path: <linux-kernel-owner+w=401wt.eu-S1751299AbZHLEMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751299AbZHLEMv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 00:12:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZHLEMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 00:12:50 -0400
Received: from smtp.flash.net.br ([201.46.240.48]:34510 "EHLO
	smtp.gru.flash.tv.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbZHLEMu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 00:12:50 -0400
In-Reply-To: <200907220915.n6M9FZG9014926@demeter.kernel.org>
References: <bug-11717-5003@http.bugzilla.kernel.org/> <200907220915.n6M9FZG9014926@demeter.kernel.org>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=ISO-8859-1; delsp=yes; format=flowed
Message-Id: <5E37A953-FAA0-4A17-B811-90E5898E4EAF@ime.usp.br>
Cc: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
From: =?ISO-8859-1?Q?Rog=E9rio_Brito?= <rbrito@ime.usp.br>
Subject: Re: [Bug 11717] Pressing suspend button suspends, but does not wakes up
Date: Wed, 12 Aug 2009 01:05:09 -0300
To: bugzilla-daemon@bugzilla.kernel.org
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, people (and Zhao in particular).

I'm adding a CC to the people in linux-kernel as we may, perhaps, get  
some ideas of how to debug this year long bug.

On Jul 22, 2009, at 9:15 AM, ykzhao <yakui.zhao@intel.com> wrote:
>
>     From your test it seems that the box can't be resumed from BIOS.

Pardon me as I'm not sure how many ways to resume a box are. I'm not  
familiar with hardware matters.

>     And if the BIOS is skipped by using "echo core > /sys/power/ 
> pm_test", it
> can be resumed.

Well, this didn't work the last time I tested. Actually, just to  
recap, I have never gotten Linux to resume this notebook at all. With  
kernel modesetting, without, just booting with /bin/bash as init etc.

The unfortunate fact is that its warranty has just run out. I am  
really interested in getting it working, as I do need this for some  
development.

The sad thing is that Windows Vista that came pre-installed with it  
supports both suspend-to-ram and suspend-to-disk without any problems  
at all, but I'm not sure what to do, as I don't know how to use  
Windows (and I'm not really willing to learn a non-Unix Operating  
System). :-/

>     And now I have no idea to fix it.

I made sure that I bought a notebook with an intel chipset, but it  
seems that this isn't exactly sufficient to get a machine properly  
working with the kernel.

That being said, while I am not willing to learn how to work with  
Windows Vista, I am open to trying some, perhaps, invasive tests  
under Linux.

Well, actually, if there is any debugger/tracer/whatever that I could  
run under Windows Vista and that can reveal important information,  
then I'm ready to go.

Any ideas, anyone?


Thanks, Rogério Brito.

