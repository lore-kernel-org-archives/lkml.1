Return-Path: <linux-kernel-owner+w=401wt.eu-S1761933AbXJQILh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761933AbXJQILh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:11:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXJQILV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:11:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:3313 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbXJQILT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:11:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=o2An4kBkGQkIbJHHa+u3OjldLhkXJRZC4XBdkNXBX4tXxpQKbn6BW0Y640b21qaI8GdWFjcHgGmT5Emb9OFa0oP7HUuCjiABqtdaL/yJIh1Zkpk+Hb7/W+v8pBwu/rKwBqWv7pMGnAQ8eoAJfXx/3g9/4CtXN2LzASGGzRw80eI=
Message-ID: <4715C39E.7070603@gmail.com>
Date: Wed, 17 Oct 2007 12:11:10 +0400
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: John Sigler <linux.kernel@free.fr>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr> <471342C8.2030305@free.fr> <4714979C.5010103@free.fr> <Pine.LNX.4.61.0710160835160.11232@chaos.analogic.com> <4714B7D7.7090005@free.fr> <4714EF81.2070405@gmail.com> <4715C337.6050705@free.fr>
In-Reply-To: <4715C337.6050705@free.fr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

John Sigler wrote:
> Alexey Starikovskiy wrote:
> 
>> John Sigler wrote:
>>
>>>          +===================================+
>>>          | Soft-Off by PWR-BTTN              |
>>>          |-----------------------------------|
>>>          | Instant-Off  ..... [v]            |
>>>          | Delay 4 Sec. ..... [ ]            |
>>>          |                                   |
>>>          |-----------------------------------|
>>>          |  ^V:Move ENTER:Accept ESC:Abort   |
>>>          +===================================+
>>>
>>> 'Instant-Off' is the appropriate setting, right?
>>
>> Actually, default should be 4 sec delay. OS should have a chance to
>> shut down the system...
> 
> I don't see why this setting would have an impact on the outcome
> of the 'halt' and 'poweroff' commands.
> 
Well, it is not possible to tell, what BIOS writer have connected to this flag...

