Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953Ab0AGPnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab0AGPnU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 10:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865Ab0AGPnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 10:43:19 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:63962 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab0AGPnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 10:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=cwHDDqqwqH8cHSpTpe83pvaDIWe4nnILS4KIRBKr2mILJUu0BrkcmoWlyd8bhpxoSY
         6DzMXabdgFbEJlSvwe4qXzgmh9CgT33GE4+j/DWqiU6IAOmogU/NqaAKsXveG2NdsEQk
         MLgmvVVkChSHI2x6OseWUmWM+bsJfplICtnsk=
Message-ID: <4B460132.3010706@gmail.com>
Date: Thu, 07 Jan 2010 07:43:46 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [bisected] sys_paccept: disable paccept() causes my macbook pro
 to  have an annoying whining sound
References: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com> <873a2ixmwy.fsf@basil.nowhere.org>
In-Reply-To: <873a2ixmwy.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/10 01:51, Andi Kleen wrote:
> Justin Mattock<justinmattock@gmail.com>  writes:
>
>> for a while I've been hearing this odd
>> annoying sound coming from my macbook pro
>> when the system is idle(no internet use tv/radio/web etc...)
>> as soon as I do anything(radio,web) the noise disappears.
>>
>> here is a  url where they are experiencing the same issue:
>> https://help.ubuntu.com/community/MacBook1-1/Hardy
>> (down under whining noise);
>>
>> here is is the result of my bisect:
>
> It's very unlikely that this patch causes power management issues.
> I would suggest you double check the bisect.
>
> -Andi
>

I can try again..

As for the power management
I didn't think so.. sounds more
like vibration of a solder joint/capacitor

Justin P. Mattock
