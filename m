Return-Path: <linux-kernel-owner+w=401wt.eu-S1752673AbYL3QIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673AbYL3QIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 11:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYL3QIF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 11:08:05 -0500
Received: from gw-ca.panasas.com ([66.104.249.162]:32380 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751252AbYL3QIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 11:08:04 -0500
Message-ID: <495A475D.7060608@panasas.com>
Date: Tue, 30 Dec 2008 18:07:57 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>,
       LKML <linux-kernel@vger.kernel.org>, stable@kernel.org,
       linux-usb@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH -stable] fix USB_STORAGE_CYPRESS_ATACB
References: <495913A6.9070007@free.fr> <20081229192431.GZ1469@one-eyed-alien.net>
In-Reply-To: <20081229192431.GZ1469@one-eyed-alien.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Dec 2008 16:07:55.0050 (UTC) FILETIME=[C64120A0:01C96A98]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Dharm wrote:
> Boaz, what's your take on this?  It "feels" to me like this should be fixed
> another way, rather than mucking directly with the srb structures.
> 
> Matt
> 
> On Mon, Dec 29, 2008 at 07:15:02PM +0100, matthieu castet wrote:
>> Hi,
>>
>> 64a87b244b9297667ca80264aab849a36f494884 broke USB_STORAGE_CYPRESS_ATACB 
>> translation.
>>
>> Could it be applied to kernel-stable ?
>>
>> Matthieu
> 
> 
> 

You are right there is an easier way.

Sorry to only respond now, we've been moving our office, and were offline.
I'll send the proper fix first thing tomorrow ASAP

Thanks
Boaz

