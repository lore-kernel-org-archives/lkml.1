Return-Path: <linux-kernel-owner+w=401wt.eu-S1763455AbZAUAao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763455AbZAUAao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 19:30:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759000AbZAUAab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 19:30:31 -0500
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:13652 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758799AbZAUAaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 19:30:30 -0500
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=0 a=CE32vBf1S_1Wk3jBroMA:9 a=EkBQLMTU7zh6rfsJ3ErDDajWfHEA:4 a=Y8cocX-fvF4A:10 a=PR-DjfqNVKsA:10
Message-ID: <49766CA3.7090508@shaw.ca>
Date: Tue, 20 Jan 2009 18:30:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Diego Calleja <diegocg@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: Faulty seagate drives, are going to be blacklisted?
References: <20090120002923.065f24ca@diego-desktop> <49753D09.8060503@shaw.ca> <20090120162612.7473aadf@diego-desktop>
In-Reply-To: <20090120162612.7473aadf@diego-desktop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Diego Calleja wrote:
> El Mon, 19 Jan 2009 20:55:05 -0600, Robert Hancock <hancockr@shaw.ca> escribió:
> 
>> There are a few drives which are currently marked to disable NCQ and 
>> warn the user that the firmware that should be upgraded:
>>
>> ST31500341AS
>> ST31000333AS
>> ST3640623AS
>> ST3640323AS
>> ST3320813AS
>> ST3320613AS
>>
>> all for firmware versions SD15 through SD19.
> 
> 
> Yes, I saw them, but apparently the NCQ bug is unrelated to this one.

I suspect it might be related, given that the firmware versions seem to 
partially overlap.

With this issue though, there isn't anything the kernel can do about the 
problem, so blacklisting doesn't seem to really make much sense.
