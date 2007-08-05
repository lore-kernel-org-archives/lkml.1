Return-Path: <linux-kernel-owner+w=401wt.eu-S1757343AbXHERiT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757343AbXHERiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:38:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751825AbXHERiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:38:11 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:60090 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbXHERiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:38:10 -0400
Date: Sun, 05 Aug 2007 11:38:00 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Page Cache question
In-reply-to: <fa.ak7dGOAL/3/Q6eQ0zKX2KgaiWdU@ifi.uio.no>
To: Adnan Khaleel <akhaleel2001@yahoo.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <46B60AF8.1020401@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.ak7dGOAL/3/Q6eQ0zKX2KgaiWdU@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adnan Khaleel wrote:
> So would it be possible to me to disable it for just a particular user space process?

It's the core of the whole VM/memory management subsystem. It's not 
something you can just disable.

It would be better if you explained what exactly you were trying to 
accomplish..

> 
> Adnan
> 
> 
>> I'm looking for a way to disable the page cache for an
> 
>> experimental NUMA system running the 2.6.17 kernel. I would prefer to
> 
>> only disable the page cache for my process and still have it be enabled
> 
>> by the rest of the system. Is there an easy way of doing this?
> 
>> Alternatively, I would be fine disabling the Page Cache altogether as well.
> 
> 
> 
> All user memory is in the page cache. Without it you could only run kernel
> 
> modules.
> 
> 
> 
> -Andi

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

