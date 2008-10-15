Return-Path: <linux-kernel-owner+w=401wt.eu-S1754993AbYJOCWC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754993AbYJOCWC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 22:22:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYJOCVu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 22:21:50 -0400
Received: from zcars04f.nortel.com ([47.129.242.57]:41659 "EHLO
	zcars04f.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYJOCVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 22:21:50 -0400
Message-ID: <48F55398.10005@nortel.com>
Date: Tue, 14 Oct 2008 20:21:12 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Kaz Kylheku <kkylheku@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: GPL question: using large contiguous memory in proprietary driver.
References: <3f43f78b0810141456r159d71e7h9763e50e7dbc0c51@mail.gmail.com> <48F5193B.1010601@nortel.com> <3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
In-Reply-To: <3f43f78b0810141623s4282f9eof87014d2dee17810@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Oct 2008 02:21:16.0343 (UTC) FILETIME=[B3BA0C70:01C92E6C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kaz Kylheku wrote:
> On Tue, Oct 14, 2008 at 3:12 PM, Chris Friesen <cfriesen@nortel.com>
> wrote:
> 
>> Kaz Kylheku wrote:
>> 
>> 
>>> I have the following question. Suppose that some proprietary
>>> driver (otherwise completely clean, based only on non-GPL
>>> symbols)
>> 
>> The fact that it's not using GPL symbols does not actually mean
>> that the driver is not a derivative work of the kernel (and thus
>> subject to the GPL).
> 
> 
> But thanks to the gracious tolerance of the kernel development 
> community, such drivers are permitted to exist.

If you're thinking of something like the Nvidia driver, the binary 
portion of that driver is cross-platform and is not a derivative work of 
the kernel.

If you sit down and write a new driver for linux, is is arguable that it 
is in fact a derivative work of the kernel and is thus subject to the GPL.

This may of course vary based on location, but I strongly suggest that 
you consult suitable legal advice before proceeding.

Chris
