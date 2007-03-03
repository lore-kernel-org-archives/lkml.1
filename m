Return-Path: <linux-kernel-owner+w=401wt.eu-S2992831AbXCCBYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992831AbXCCBYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 20:24:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992862AbXCCBYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 20:24:43 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:22530 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992831AbXCCBYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 20:24:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=XWUms2miivpfqRy6m87wMNhPfD6VbilEKZ4bst9vPvh4vV4BykC2gsOM28ZXRaRszwCub+yR6jkbwhJ1m2+Sxd7T51bMureyQNCIVosU6SL1G6yyQoRtagtozm8IowA0Eb0nG6Z0k56lz/ffT/m19FXgs6safBLeYQWchVorcpk=
Message-ID: <45E8CDF3.7010406@googlemail.com>
Date: Sat, 03 Mar 2007 02:22:59 +0100
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc2-mm1
References: <20070302030026.5eef0c92.akpm@linux-foundation.org>	<6bffcb0e0703021542k4f882531r21807c7efdbd0ebc@mail.gmail.com> <20070302164009.a2aa6cbc.akpm@linux-foundation.org>
In-Reply-To: <20070302164009.a2aa6cbc.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton napisał(a):
> On Sat, 3 Mar 2007 00:42:33 +0100
> "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:
> 
>> On 02/03/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>>> Temporarily at
>>>
>>>   http://userweb.kernel.org/~akpm/2.6.21-rc2-mm1/
>>>
>> I have noticed some strange system behavior. When i try to build a
>> kernel (medium load) - X, keyboard, mouse and sound hangs.
>>
>> I can ping machine and I can use magic SysRq key, but that's all.
>>
>> 2.6.20-mm2 was fine, 2.6.21-rc2 works well (over 800 patches since
>> 2.6.20-mm2 - great...)
>>
>> NIL (Nothing Interesting in Logs)
>>
> 
> Can we see the sysrq-T output please?
> 

http://www.stardust.webpages.pl/files/tbf/bitis-gabonica/2.6.21-rc2-mm1/sys.log

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group (PL)
(http://www.stardust.webpages.pl/ltg/)
LTG - Linux Testers Group (EN)
(http://www.stardust.webpages.pl/linux_testers_group_en/)
