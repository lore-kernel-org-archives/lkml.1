Return-Path: <linux-kernel-owner+w=401wt.eu-S1756114AbZJLK5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114AbZJLK5k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 06:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754543AbZJLK5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 06:57:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:12609 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458AbZJLK5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 06:57:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=BAuKo5wGor90tgi6U+qViZPx6Eo4YEITtIsc/DSFRuWYsr1aJ8a0jKlVKYA3Xj+bAA
         uoQ0Z5aF8fthd9SBCl9cXqbgiIlNJm09rT0cDtehidrC9rhiSB1wKgOVVQXQwNNoxXcQ
         kXrL4X2yFy0WHjGAIwON7QZbr25nV+iU/2qh8=
Message-ID: <4AD30B34.30609@gmail.com>
Date: Mon, 12 Oct 2009 12:55:48 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.4pre) Gecko/20090915 SUSE/3.0b4-2.8 Thunderbird/3.0b4
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: kenchen@google.com,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: broken do_each_pid_{thread,task}
References: <494581D7.6000203@gmail.com> <20081215102415.GA11106@redhat.com> <49463679.7080306@gmail.com> <20081215110238.GA15606@redhat.com> <4946406D.6000506@gmail.com> <20081215115108.GA17577@redhat.com>
In-Reply-To: <20081215115108.GA17577@redhat.com>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2008 12:51 PM, Oleg Nesterov wrote:
> On 12/15, Jiri Slaby wrote:
>>
>> Oleg Nesterov napsal(a):
>>> On 12/15, Jiri Slaby wrote:
>>>> (And it's not compiler which complains
>>>> here.)
>>>
>>> Ah, OK, thanks. Just curious, and who does?
>>
>> A static analyzer. Stay tuned, we will announce it later, it's in the state
>> of development :).
> 
> Great, thanks ;)

It got released a minute ago. If you are interested:
http://lkml.org/lkml/2009/10/12/133
