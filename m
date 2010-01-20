Return-Path: <linux-kernel-owner+w=401wt.eu-S1753118Ab0ATMMJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab0ATMMJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 07:12:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862Ab0ATMMH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 07:12:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967Ab0ATMMF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 07:12:05 -0500
Message-ID: <4B56F30C.5040605@redhat.com>
Date: Wed, 20 Jan 2010 14:11:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, Gleb Natapov <gleb@redhat.com>,
       Julia Lawall <julia@diku.dk>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: only allow one gsi per fd
References: <20100113165809.GA13334@redhat.com> <4B53052D.3020905@redhat.com> <20100120113641.GB9610@redhat.com> <4B56EE60.4030009@redhat.com> <20100120115911.GA9761@redhat.com>
In-Reply-To: <20100120115911.GA9761@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2010 01:59 PM, Michael S. Tsirkin wrote:
>
>    
>>> I'm guessing we need this for 2.6.32 stable and 2.6.33 as well?
>>>
>>>        
>> That's what 'queued' means.
>>      
> Aha. Which git branch is used for these?
>
>    

kvm-updates/2.6.33.  Cc: stable@kernel.org means it will get 
auto-submitted to 2.6.32.

-- 
error compiling committee.c: too many arguments to function

