Return-Path: <linux-kernel-owner+w=401wt.eu-S932087AbXBKTTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087AbXBKTTG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 14:19:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932084AbXBKTS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 14:18:58 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:38629 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932075AbXBKTSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 14:18:48 -0500
Message-ID: <45CF6C19.5060408@gmail.com>
Date: Sun, 11 Feb 2007 20:18:49 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
Cc: Avi Kivity <avi@qumranet.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       kvm-devel@lists.sourceforge.net
Subject: Re: KVM oops: killing interrupt handler
References: <45CE20E5.8000107@gmail.com> <45CEDB95.2020705@qumranet.com> <4af2d03a0702110601g36b4780fuec82be8290d6a397@mail.gmail.com> <45CF3BF0.2070103@qumranet.com> <45CF4B23.5050401@gmail.com> <45CF4DE9.8080904@qumranet.com> <45CF5476.5030204@gmail.com>
In-Reply-To: <45CF5476.5030204@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby napsal(a):
> Avi Kivity napsal(a):
>> Jiri Slaby wrote:
>>> Avi Kivity napsal(a):
>>>> kvm suspend/resume support is only present in -mm (what's more, I 
>>>> don't think in any released -mm).  A workaround is to rmmod 
>>>> kvm_intel before suspending.
>>>
>>> BTW. will kvm-13's external module work?
>>
>> Try and report back :)
[...]
> Now, he's going to test it...

Nice to report, that it works, good work!

regards,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
