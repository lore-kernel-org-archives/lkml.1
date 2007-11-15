Return-Path: <linux-kernel-owner+w=401wt.eu-S1762645AbXKORGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762645AbXKORGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 12:06:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbXKORFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 12:05:51 -0500
Received: from zrtps0kn.nortel.com ([47.140.192.55]:49928 "EHLO
	zrtps0kn.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbXKORFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 12:05:50 -0500
Message-ID: <473C7C62.9030100@nortel.com>
Date: Thu, 15 Nov 2007 11:05:38 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Michael Gerdau <mgerdau@tiscali.de>
CC: Philippe Elie <phil.el@wanadoo.fr>,
       Russell Leighton <russ@elegant-software.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: OT: Does Linux have any "Perfect Code"
References: <c9d133bdb3481fbc01a572d948049f5e@elegant-software.com> <20071115082746.GA2885@zaniah> <200711151416.54570.mgerdau@tiscali.de>
In-Reply-To: <200711151416.54570.mgerdau@tiscali.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Nov 2007 17:05:42.0824 (UTC) FILETIME=[C16E3280:01C827A9]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Gerdau wrote:

> That having said:
> I really do like such obvious (as in: for those knowing the stuff anyway)
> comments when looking at code and probably concepts I'm not familiar with.
> 
> IMO there is no need to belittle this type of comment. IMO any casual
> reader not familiar with the whole set of functions possibly involved
> will be thankful for this type of comment - I certainly am.

Obvious comments explaining _what_ the code is doing are annoying. 
They're fluff.  You can see what the code is doing.

The critical comments are the ones that explain _why_ and _how_.  The 
comments should give the higher level view as to the rationale for that 
code.

Of course if you've got some highly-optimized bit of black magic there 
had better be some good comments explaining what's going on...but there 
should also be some comments explaining why we need the magic in the 
first place.

Chris
