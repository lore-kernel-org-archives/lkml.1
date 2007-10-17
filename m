Return-Path: <linux-kernel-owner+w=401wt.eu-S1762041AbXJQIJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762041AbXJQIJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 04:09:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbXJQIJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 04:09:31 -0400
Received: from smtp4-g19.free.fr ([212.27.42.30]:37566 "EHLO smtp4-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533AbXJQIJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 04:09:29 -0400
Message-ID: <4715C337.6050705@free.fr>
Date: Wed, 17 Oct 2007 10:09:27 +0200
From: John Sigler <linux.kernel@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061108 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alexey Starikovskiy <aystarik@gmail.com>
CC: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       robert.moore@intel.com, len.brown@intel.com
Subject: Re: halt does not shut the system down
References: <470A58AF.9080402@free.fr> <470C9731.6030200@free.fr> <470F4535.3050004@free.fr> <470F4F58.4080900@gmail.com> <470F7264.8070205@free.fr> <471342C8.2030305@free.fr> <4714979C.5010103@free.fr> <Pine.LNX.4.61.0710160835160.11232@chaos.analogic.com> <4714B7D7.7090005@free.fr> <4714EF81.2070405@gmail.com>
In-Reply-To: <4714EF81.2070405@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Starikovskiy wrote:

> John Sigler wrote:
> 
>>          +===================================+
>>          | Soft-Off by PWR-BTTN              |
>>          |-----------------------------------|
>>          | Instant-Off  ..... [v]            |
>>          | Delay 4 Sec. ..... [ ]            |
>>          |                                   |
>>          |-----------------------------------|
>>          |  ^V:Move ENTER:Accept ESC:Abort   |
>>          +===================================+
>>
>> 'Instant-Off' is the appropriate setting, right?
>
> Actually, default should be 4 sec delay. OS should have 
> a chance to shut down the system...

I don't see why this setting would have an impact on the outcome
of the 'halt' and 'poweroff' commands.
