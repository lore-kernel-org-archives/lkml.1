Return-Path: <linux-kernel-owner+w=401wt.eu-S1753776AbZAaHW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753776AbZAaHW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 02:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbZAaHWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 02:22:20 -0500
Received: from gw.goop.org ([64.81.55.164]:39744 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbZAaHWT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 02:22:19 -0500
Message-ID: <4983FC29.9040907@goop.org>
Date: Fri, 30 Jan 2009 23:22:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Brian Gerst <brgerst@gmail.com>
Subject: Re: [PATCH 3/3] xen: use direct ops on 64-bit
References: <4983AC8A.6050501@goop.org> <4983E313.4070902@gmail.com>
In-Reply-To: <4983E313.4070902@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Enable the use of the direct vcpu-access operations on 64-bit.
>>
>> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>>     
>
> Hmmm... these three patches conflict with the previous two patches.
> I'll soon send out a new tree.  Can you please wait a bit and refresh
> the patches?

Sorry about that; I had to do a fair amount of hacking to get things 
going in the end.  I mailed out those other patches prematurely after 
"testing" them with the wrong kernel.

I'll send updated fixes when I see your changes appear in tip.git.

    J
