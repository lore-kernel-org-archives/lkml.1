Return-Path: <linux-kernel-owner+w=401wt.eu-S1754067AbZLVQVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067AbZLVQVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 11:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbZLVQVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 11:21:46 -0500
Received: from qw-out-2122.google.com ([74.125.92.24]:51197 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641AbZLVQVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 11:21:44 -0500
Message-ID: <4B30F214.80206@codemonkey.ws>
Date: Tue, 22 Dec 2009 10:21:40 -0600
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Gregory Haskins <gregory.haskins@gmail.com>,
       Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       kvm@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org,
       "alacrityvm-devel@lists.sourceforge.net" 
	<alacrityvm-devel@lists.sourceforge.net>
Subject: Re: [GIT PULL] AlacrityVM guest drivers for 2.6.33
References: <4B1D4F29.8020309@gmail.com> <87637zdy9g.fsf@basil.nowhere.org> <4B30E654.40702@codemonkey.ws> <200912221701.56840.bzolnier@gmail.com>
In-Reply-To: <200912221701.56840.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2009 10:01 AM, Bartlomiej Zolnierkiewicz wrote:
>> new e1000 driver is more superior in architecture and do the required
>> work to make the new e1000 driver a full replacement for the old one.
>>      
> Right, like everyone actually does things this way..
>
> I wonder why do we have OSS, old Firewire and IDE stacks still around then?
>    

And it's always a source of pain, isn't it.

>>> I also personally don't see a big problem in having another set of
>>> virtual drivers -- Linux already has plenty (vmware, xen, virtio, power,
>>> s390-vm, ...) and it's not that they would be a particular maintenance
>>> burden impacting the kernel core.
>>>        
> Exactly, I also don't see any problem here, especially since AlacrityVM
> drivers have much cleaner design / internal architecture than some of their
> competitors..
>    

Care to provide some actual objective argument to why it's better than 
what we already have?

Regards,

Anthony Liguori

