Return-Path: <linux-kernel-owner+w=401wt.eu-S1757428AbZAVKQq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428AbZAVKQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 05:16:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbZAVKQh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 05:16:37 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:62578 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089AbZAVKQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 05:16:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ki1m98obDFdXFi0rL9pQotZG8mXUEpztmQIs09Suogcm7BSfjC+AoZNtYDbBMru9Vt
         eX/6Lco7DWR/hbdzRYr1lJTkkiUlyjYEMduiOb4CmcJlKSDMzwpbzkoEgQsiB2rXpme4
         HiEHf9kNXVyru20P7k+xWAkGeLclsfTAs/8nw=
Message-ID: <497847D0.4050700@gmail.com>
Date: Thu, 22 Jan 2009 11:17:52 +0100
From: Jacek Luczak <difrost.kernel@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: astarikovskiy@suse.de, len.brown@intel.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ACPI] GPE storm detected on FS Amilo Pro
References: <4977352B.1040303@gmail.com> <200901211700.48357.rjw@sisk.pl>
In-Reply-To: <200901211700.48357.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

> So everything appears to be OK except that your hardware has a problem,
> which is correctly worked around and the message just tells you what happens.

Most probably yes, but I'm using that kernel really shortly so there might be
some issues that I didn't noticed. This of course doesn't mean that here we have
 bug, I was just bit confused with that message.

>> NOTE: In git kernel I've noticed that after boot and obtaining IP from DHCP I've
>> got such message:
>>
>> Jan 21 14:44:32 difrost kernel: sky2 eth0: enabling interface
>> Jan 21 14:44:33 difrost kernel: sky2 eth0: Link is up at 100 Mbps, full duplex,
>> flow control rx
>> Jan 21 14:45:36 difrost kernel: ACPI: EC: missing confirmations, switch off
>> interrupt mode.
>>
>> This is not fully reproducible, didn't shown on [4].
> 
> This may be related to the issue behind the GPM storm message.

Is it sth serious? I'm really lost here.

-Jacek
