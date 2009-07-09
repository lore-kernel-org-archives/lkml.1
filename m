Return-Path: <linux-kernel-owner+w=401wt.eu-S1757819AbZGII6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbZGII6H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 04:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756191AbZGII54
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 04:57:56 -0400
Received: from an-out-0708.google.com ([209.85.132.240]:45148 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZGII5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 04:57:55 -0400
Message-ID: <4A55B10B.7010200@petalogix.com>
Date: Thu, 09 Jul 2009 10:57:47 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, mingo@elte.hu,
       arnd@arndb.de, lethal@linux-sh.org, ltp-list@lists.sourceforge.net
Subject: Re: mmap hw behavior
References: <4A54DF6F.1010405@petalogix.com>	<20090708.110624.104984745.davem@davemloft.net>	<4A54FFFE.10306@petalogix.com> <20090708.181551.189345850.davem@davemloft.net>
In-Reply-To: <20090708.181551.189345850.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Michal Simek <michal.simek@petalogix.com>
> Date: Wed, 08 Jul 2009 22:22:22 +0200
>
>   
>> Can you please point me to any code which exactly do this? (for example
>> file mm/mmap.c line from ... to ... )
>>     
>
> Sorry I don't have time to read the source code for you.
> I'd have to look it up too, just like you.
>   
I found it - Microblaze hasn't defined tlb_flush macro.

Thanks for your help,
Michal

-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663

