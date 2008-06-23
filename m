Return-Path: <linux-kernel-owner+w=401wt.eu-S1754909AbYFWHNc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754909AbYFWHNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 03:13:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYFWHNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 03:13:20 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:30323 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbYFWHNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 03:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FxVPtrJZWojv2D3GSZtAtJcsWC8lQur9/e+SDRonksUB1BjB44OeyJEh+VCnPOkjy3
         MI7lkZ/SMhvbqCNpnmGvuXiKlTmjC884nWGwTOS6M4HPEr47GeMqZvmFXInQ8yNTHJm3
         E3Ore5yCt644sC77m6EDzxlJo+Xekq820yWAc=
Message-ID: <dd18b0c30806230013x5446991bi9eba7623ffaae131@mail.gmail.com>
Date: Mon, 23 Jun 2008 07:13:17 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: stuck tcp connections 2.6.26-rc7
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
In-Reply-To: <20080622205927.301501e7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30806221109t2ff73f9ai52f6716748648a79@mail.gmail.com>
	 <20080622205927.301501e7.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 3:59 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Sun, 22 Jun 2008 18:09:16 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
>
>> Hello; I too am experiencing internet connectivity problems, for  a
>> while I thought
>> It was due to low bandwidth(or being ddos attacked) but yesterday I
>> noticed with watch netstat -ntu
>> send-Q was stuck on a number; the connection would not go to TIME_WAIT
>> resulting in music to pause, and t.v. to freeze.
>> In my experiences running xmms streaming music is fine, no problems,
>> but as soon as
>> you watch something with flash player the stream start's getting
>> really bad. In the past with older kernel's
>> I usually can watch t.v.(with flash) and stream music at the same time
>> without any trouble.
>> lately I've been Running the kernel in No forced Preemption with a
>> time frequency at 100. having the kernel set in this mode really shows
>> the connection problems, but if I change the preemption to another,
>> and bump up the timer frequency the poor internet connection is not as
>> bad(or stuck tcp) but still prevalent. more pops in the music, and
>> sudden internet loss for around five seconds, then goes back
>> So from over here streaming music has no problems from what I can see,
>> but as soon as I watch media, it becomes a mess.
>
> (cc netdev)
>


Cool, Thanks for sending the cc
regards;
-- 
Justin P. Mattock
