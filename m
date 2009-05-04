Return-Path: <linux-kernel-owner+w=401wt.eu-S1757044AbZEDVBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbZEDVBr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 17:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZEDVBh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 17:01:37 -0400
Received: from zrtps0kp.nortel.com ([47.140.192.56]:37030 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbZEDVBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 17:01:37 -0400
Message-ID: <49FF57AC.7070104@nortel.com>
Date: Mon, 04 May 2009 15:01:32 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Nico_Sch=FCmann?= <spam@nico22.de>
CC: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
Subject: Re: CFS not suitable for desktop computers
References: <49FDEFD1.8020608@nico22.de> <1241424835.26855.102.camel@marge.simson.net> <49FF06D0.80109@nico22.de>
In-Reply-To: <49FF06D0.80109@nico22.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 04 May 2009 21:01:33.0730 (UTC) FILETIME=[81711820:01C9CCFB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nico Schümann wrote:
> Thank you Ray Lee and Mike Galbraith for your responses, I ran the 
> script and attached its gathered information.
> 
> Mike Galbraith wrote:
>> How hard is hard?  Can you describe the loads you're having trouble
>> with, and the hardware you're running them on?
>>
>>   
> I could reproduce "hard" load by just compiling the linux kernel, make 
> -j3 while reading mails with Thunderbird, which is not that hard 
> foreground load. Thunderbird starts reacting really slowly while compiling.

I wonder if this could be related to I/O rather than the task scheduler 
proper.

Chris
