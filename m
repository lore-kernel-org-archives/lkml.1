Return-Path: <linux-kernel-owner+w=401wt.eu-S1754433Ab0AEQgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab0AEQgF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 11:36:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932068Ab0AEQf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 11:35:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126Ab0AEQf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 11:35:56 -0500
Message-ID: <4B436A6A.8020003@redhat.com>
Date: Tue, 05 Jan 2010 11:35:54 -0500
From: Peter Jones <pjones@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/firmware/iscsi_ibft.c: use %pM to show MAC address
References: <BD79186B4FD85F4B8E60E381CAEE19090200F669@mi8nycmail19.Mi8.com> <4B420C06.3080402@redhat.com> <BD79186B4FD85F4B8E60E381CAEE190902089268@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190902089268@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/05/2010 11:33 AM, H Hartley Sweeten wrote:
> On Monday, January 04, 2010 8:41 AM, Peter Jones wrote:
>> On 12/30/2009 02:49 PM, H Hartley Sweeten wrote:
>>> Use the %pM kernel extension to display the MAC address.
>>>
>>> Also, remove the 'mac' variable and use nic->mac directly.
>>>
>>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>>> Cc: Peter Jones <pjones@redhat.com>
>>
>> Looks good to me.
>>
>> Acked-by: Peter Jones <pjones@redhat.com>
> 
> Hello Peter,
> 
> Will you be merging this?
> 
> I sent a number of similar patches to the netdev list.  David Miller
> had merge issues with them due to a whitespace problem at the end of
> the patches.  I have figure out the issue and am reposting the patch
> series now.  If you have not merged this I will fix this one also and
> send it to him with the others.

You sending it to him for merge is fine by me.

-- 
        Peter

All parts should go together without forcing. You must remember that
the parts you are  reassembling were disassembled by you.  Therefore,
if you can't get them together again, there must be a reason. By all
means, do not use a hammer.
		-- IBM maintenance manual, 1925
