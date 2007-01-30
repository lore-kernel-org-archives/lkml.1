Return-Path: <linux-kernel-owner+w=401wt.eu-S965121AbXA3AZr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121AbXA3AZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jan 2007 19:25:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965120AbXA3AZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jan 2007 19:25:47 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:50850 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965128AbXA3AZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jan 2007 19:25:46 -0500
Message-ID: <45BE9043.5020508@nortel.com>
Date: Mon, 29 Jan 2007 18:24:35 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Kevin Nicoll <blort128@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Multiple ip= boot arguments?
References: <e4fa6c610701291036r7ff384e4u78d3995ab3d042d8@mail.gmail.com> <Pine.LNX.4.61.0701292146470.5077@yvahk01.tjqt.qr> <45BE8AAA.9020308@zytor.com>
In-Reply-To: <45BE8AAA.9020308@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jan 2007 00:24:38.0521 (UTC) FILETIME=[06EF2690:01C74405]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Jan Engelhardt wrote:
>>
>>> or if I'm supposed to use a startup script instead.
>>
>> This is the preffered way nowadays. One day, hopefully,
>> CONFIG_IP_PNP can go away.
>>
> It could be done reasonably easy, you know... :-/

If CONFIG_IP_PNP is going to go away, what is the proposed mechanism for 
netboot devices to determine the proper source address to use when 
searching for a rootfs to use?


Chris
