Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbXJVJLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbXJVJLb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 05:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbXJVJLY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 05:11:24 -0400
Received: from il.qumranet.com ([82.166.9.18]:38787 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbXJVJLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 05:11:23 -0400
Message-ID: <471C690D.7080908@qumranet.com>
Date: Mon, 22 Oct 2007 11:10:37 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: kvm-devel@lists.sourceforge.net, Laurent Vivier <Laurent.Vivier@bull.net>,
       linux-kernel@vger.kernel.org, borntraeger@de.ibm.com
Subject: Re: [kvm-devel] [PATCH] move kvm_guest_exit() after	local_irq_enable()
References: <47135D1B.1060004@bull.net>	<11927135412363-git-send-email-Laurent.Vivier@bull.net>	<20071022082604.GA28528@elte.hu> <471C647A.50908@qumranet.com> <20071022085703.GA2781@elte.hu>
In-Reply-To: <20071022085703.GA2781@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>
>> Note the kvm part is already in my 2.6.24 queue.
>>     
>
> ok, then please push the whole patch to Linus, the scheduler bits are:
>
>   Acked-by: Ingo Molnar <mingo@elte.hu>
>   

Sure, thanks.

-- 
error compiling committee.c: too many arguments to function

