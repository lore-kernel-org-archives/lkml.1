Return-Path: <linux-kernel-owner+w=401wt.eu-S1756083AbZHQPSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083AbZHQPSd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 11:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756080AbZHQPSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 11:18:33 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47626 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbZHQPSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 11:18:32 -0400
Message-ID: <4A8974B0.8050604@redhat.com>
Date: Mon, 17 Aug 2009 18:18:08 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Gregory Haskins <gregory.haskins@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Gregory Haskins <ghaskins@novell.com>,
       kvm@vger.kernel.org, alacrityvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 3/6] vbus: add a "vbus-proxy" bus model for	vbus_driver
 objects
References: <20090814154125.26116.70709.stgit@dev.haskins.net> <20090814154308.26116.46980.stgit@dev.haskins.net> <20090815103243.GA26749@elte.hu> <4A87C3B9.2040206@redhat.com> <4A896648.9040707@gmail.com> <4A897057.2050504@redhat.com> <4A8972C3.30202@gmail.com>
In-Reply-To: <4A8972C3.30202@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2009 06:09 PM, Gregory Haskins wrote:
>
>> We've been through this before I believe.  If you can point out specific
>> differences that make venet outperform virtio-net I'll be glad to hear
>> (and steal) them though.
>>
>>      
> You sure know how to convince someone to collaborate with you, eh?
>
>    

If I've offended you, I apologize.

> Unforunately, i've answered that question numerous times, but it
> apparently falls on deaf ears.
>    

Well, I'm sorry, I truly don't think I've had that question answered 
with specificity.  I'm really interested in it (out of a selfish desire 
to improve virtio), but the only comment I recall from you was to the 
effect that the virtio rings were better than ioq in terms of cache 
placement.

-- 
error compiling committee.c: too many arguments to function

