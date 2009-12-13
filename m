Return-Path: <linux-kernel-owner+w=401wt.eu-S1754056AbZLMUiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056AbZLMUiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 15:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753539AbZLMUiM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 15:38:12 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:50130 "HELO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752903AbZLMUiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 15:38:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=EK0u7940ROXll4RZl07v3WjMBhr0SiAue/qjiHKn2kMU/YcVj1v8cacU9sXEDfnLA2
         qIF6Hmloa9AwazPoOdsTNp06td20N2yWhLP09E4qpvmdC/NEwFif/tjIrAbriA62vslC
         feG1jo2tj2ZHoGI0mSPBhC7UWjvTlP9ZXaw3A=
Message-ID: <4B254ED1.5040805@gmail.com>
Date: Sun, 13 Dec 2009 14:30:09 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Christian Hartmann <cornogle@googlemail.com>
CC: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: Q: Why I do have to restart alsa everytime after a resume from
    disk/ram ? Is this alsa- or kernel or config related??
References: <ffd8902a0912110121k795223ar6af644c41cd357b8@mail.gmail.com>	 <4B22DD11.7000905@gmail.com> <ffd8902a0912121351x3b29bcf8pc402f77cba7afa88@mail.gmail.com>
In-Reply-To: <ffd8902a0912121351x3b29bcf8pc402f77cba7afa88@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2009 03:51 PM, Christian Hartmann wrote:
> sorry,
>
> here are some logs&&  configs attached:
>
> cheers
> chris
>
> 2009/12/12 Robert Hancock<hancockrwd@gmail.com>:
>> On 12/11/2009 03:21 AM, Christian Hartmann wrote:
>>>
>>> hello list,
>>>
>>> everytime I suspended to disk or to ram, regardless of the used kernel
>>> (git or stable from distri), I must restart alsa to hear sound again.
>>> searched google and tried a lot but still the same awful behaviour.
>>> Has anybode some suggestions for me? is this alsa related ? or is this
>>> a kernel issue which could be dealt here?
>>

That might help, but you didn't actually answer either of these questions:

>> I'm not sure what you mean by restarting ALSA, do you mean reloading the
>> audio device module or something?
>>
>> You didn't mention which kind of sound hardware you were using either..
>>

