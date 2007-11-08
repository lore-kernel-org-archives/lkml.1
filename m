Return-Path: <linux-kernel-owner+w=401wt.eu-S1759508AbXKHBGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759508AbXKHBGR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 20:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754996AbXKHBGC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 20:06:02 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:51440 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752999AbXKHBGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 20:06:00 -0500
Message-ID: <473260FF.1030101@us.ibm.com>
Date: Wed, 07 Nov 2007 19:06:07 -0600
From: Anthony Liguori <aliguori@us.ibm.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rusycorp.com.au>, virtualization@lists.osdl.org
Subject: Re: [PATCH][VIRTIO] Fix vring_init() ring computations
References: <11944039492411-git-send-email-aliguori@us.ibm.com> <200711071657.40992.rusty@rustcorp.com.au>
In-Reply-To: <200711071657.40992.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> On Wednesday 07 November 2007 13:52:29 Anthony Liguori wrote:
>   
>> This patch fixes a typo in vring_init(). 
>>     
>
> Thanks, applied.
>
> I've put it in the new, experimental virtio git tree on git.kernel.org.
>   

Hrm, perhaps you forgot to push?  I don't see it in the tree although I 
see the config ops refactoring.

Regards,

Anthony Liguori

> Cheers,
> Rusty.
>   

