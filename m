Return-Path: <linux-kernel-owner+w=401wt.eu-S1758100AbZCaMir@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100AbZCaMir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 08:38:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754905AbZCaMig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 08:38:36 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754013AbZCaMif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 08:38:35 -0400
Message-ID: <49D20DAF.6000805@redhat.com>
Date: Tue, 31 Mar 2009 15:33:51 +0300
From: Izik Eidus <ieidus@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org,
       avi@redhat.com, aarcange@redhat.com, chrisw@redhat.com, riel@redhat.com,
       jeremy@goop.org, mtosatti@redhat.com, hugh@veritas.com, corbet@lwn.net,
       yaniv@redhat.com, dmonakhov@openvz.org
Subject: Re: [PATCH 0/4] ksm - dynamic page sharing driver for linux
References: <1238457560-7613-1-git-send-email-ieidus@redhat.com> <49D174FC.80900@codemonkey.ws>
In-Reply-To: <49D174FC.80900@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anthony Liguori wrote:
> Izik Eidus wrote:
>> I am sending another seires of patchs for kvm kernel and kvm-userspace
>> that would allow users of kvm to test ksm with it.
>> The kvm patchs would apply to Avi git tree.
>>   
> Any reason to not take these through upstream QEMU instead of 
> kvm-userspace?  In principle, I don't see anything that would prevent 
> normal QEMU from almost making use of this functionality.  That would 
> make it one less thing to eventually have to merge...

The changes for the kvm-userspace were just provided for testing it...
After we will have ksm inside the kernel we will send another patch to 
qemu-devel that will add support for it.

>
> Regards,
>
> Anthony Liguori

