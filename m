Return-Path: <linux-kernel-owner+w=401wt.eu-S1753680AbZGAHeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbZGAHeY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753404AbZGAHeP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:34:15 -0400
Received: from mx2.redhat.com ([66.187.237.31]:49376 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbZGAHeN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:34:13 -0400
Message-ID: <4A4B11A6.6080402@redhat.com>
Date: Wed, 01 Jul 2009 10:35:02 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Lightning/1.0pre Thunderbird/3.0b2
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Greg KH <gregkh@suse.de>, Stefan Lippers-Hollmann <s.L-H@gmx.de>,
       linux-kernel@vger.kernel.org, ying.huang@intel.com, stable@kernel.org
Subject: Re: patch kvm-add-vt-x-machine-check-support.patch added to	2.6.30-stable
 tree
References: <20090629184144.76C9948FD3@coco.kroah.org> <200907010053.40900.s.L-H@gmx.de> <20090630234206.GA22546@suse.de> <4A4B0BB1.2010102@linux.intel.com>
In-Reply-To: <4A4B0BB1.2010102@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/2009 10:09 AM, Andi Kleen wrote:
>
>> Thanks, I was building without kvm enabled in my configs and missed this
>> one.
>>
>> I've added these two other patches and everything looks better.
>
> If you prefer I also have an original patch which didn't depend on any
> other KVM patches. But the other ones look harmless enough and it's 
> probably
> better to stay nearer mainline.

I'd prefer your standalone patch Andi.  Patches often look harmless but 
aren't, and I'd hate to introduce regressions into 2.6.30.*.

-- 
error compiling committee.c: too many arguments to function

