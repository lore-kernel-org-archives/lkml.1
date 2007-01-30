Return-Path: <linux-kernel-owner+w=401wt.eu-S965530AbXA3OnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965530AbXA3OnU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965532AbXA3OnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:43:20 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:46257 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965528AbXA3OnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:43:18 -0500
Message-ID: <45BF5984.1030508@garzik.org>
Date: Tue, 30 Jan 2007 09:43:16 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] libata: fix translation for START STOP UNIT
References: <45BD4E0A.7060501@shaw.ca> <45BF5525.5040709@garzik.org> <45BF57EA.6060201@shaw.ca>
In-Reply-To: <45BF57EA.6060201@shaw.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Hancock wrote:
> Jeff Garzik wrote:
>> * Include the patch inline rather than as an attachment.  Even a 
>> text/plain attachment is very difficult to review and quote in popular 
>> email programs.
>>
>>     Jeff
> 
> I'd love to, but unfortunately nobody seems to have come up with a way 
> of doing this in Thunderbird that keeps it from mangling whitespace 
> without a ton of hassle. I was able to get it to cooperate once (sort 
> of, anyway, I think it may have still damaged something on the first 
> try), but it required mangling a bunch of settings that made using it 
> for normal mail impossible.
> 
> The last time I looked, the main "how-to" page I found had an addendum 
> that "I gave up on this, it's too hard, I just attach the patches". If 
> anyone has gotten any new insight..

Just use "cat mail | sendmail -t" or git-send-email, Thunderbird will 
never get this stuff right.

I'm fighting Thunderbird right this second, in fact, because it randomly 
decided to stop supporting drag-n-drop to sub-folders in Fedora Core 6 :(

	Jeff



