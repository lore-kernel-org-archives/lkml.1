Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbXAaIWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbXAaIWi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 03:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932117AbXAaIWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 03:22:38 -0500
Received: from dvhart.com ([64.146.134.43]:37222 "EHLO dvhart.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932112AbXAaIWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 03:22:37 -0500
Message-ID: <45C051AC.6060107@mbligh.org>
Date: Wed, 31 Jan 2007 00:22:04 -0800
From: "Martin J. Bligh" <mbligh@mbligh.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20070104)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] libata: fix translation for START STOP UNIT
References: <45BD4E0A.7060501@shaw.ca> <45BF5525.5040709@garzik.org> <45BF57EA.6060201@shaw.ca> <45BF5984.1030508@garzik.org>
In-Reply-To: <45BF5984.1030508@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> Jeff Garzik wrote:
>>> * Include the patch inline rather than as an attachment.  Even a 
>>> text/plain attachment is very difficult to review and quote in 
>>> popular email programs.
>>>
>>>     Jeff
>>
>> I'd love to, but unfortunately nobody seems to have come up with a way 
>> of doing this in Thunderbird that keeps it from mangling whitespace 
>> without a ton of hassle. I was able to get it to cooperate once (sort 
>> of, anyway, I think it may have still damaged something on the first 
>> try), but it required mangling a bunch of settings that made using it 
>> for normal mail impossible.
>>
>> The last time I looked, the main "how-to" page I found had an addendum 
>> that "I gave up on this, it's too hard, I just attach the patches". If 
>> anyone has gotten any new insight..
> 
> Just use "cat mail | sendmail -t" or git-send-email, Thunderbird will 
> never get this stuff right.
> 
> I'm fighting Thunderbird right this second, in fact, because it randomly 
> decided to stop supporting drag-n-drop to sub-folders in Fedora Core 6 :(

http://mbligh.org/linuxdocs/Email/Clients/Thunderbird

Describes how to fix this.

M.
