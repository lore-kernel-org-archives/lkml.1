Return-Path: <linux-kernel-owner+w=401wt.eu-S1756800AbXEIOeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800AbXEIOeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 10:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXEIOdx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 10:33:53 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:55436 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1749667AbXEIOdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 10:33:53 -0400
Date: Wed, 09 May 2007 08:32:35 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: increase Linux kernel address space 3.5 G memory on Redhat
 Enterprise
In-reply-to: <fa.Ugxu6mcPKadIJtKhwYUZQfIVyZ0@ifi.uio.no>
To: linux@horizon.com
Cc: linux-kernel@vger.kernel.org, mzhao@lizotech-inc.com
Message-id: <4641DB83.3070108@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.Ugxu6mcPKadIJtKhwYUZQfIVyZ0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

linux@horizon.com wrote:
>> Hi:
>> I am running Redhat Linux Enterprise version 4 update 4 on a dual-core
>> 4G memory machine.  There are many references on the web talking about
>> increasing default user address space to 3.5 G however lacking specific
>> instructions. My questions:
>>
>> 1. What is the specific steps to be done for the kernel to support 3.5 G 
>>    address space?
>> 2. Do I need to re-compile kernel to make this happen? If so, any 
>>    specific instruction?

If this is a dual-core box then quite likely it also supports 64-bit, 
that would be a much safer option than messing with the kernel/user 
split and reducing the kernel memory available so much.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

