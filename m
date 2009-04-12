Return-Path: <linux-kernel-owner+w=401wt.eu-S1760072AbZDLLTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760072AbZDLLTX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 07:19:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957AbZDLLTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 07:19:09 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:44991 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbZDLLTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 07:19:05 -0400
Message-ID: <49E1CE26.9050401@garzik.org>
Date: Sun, 12 Apr 2009 07:19:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sata_sx4: refresh and convert to new EH
References: <20090408200511.GA24071@havoc.gtf.org> <a4423d670904111946w2a8f3839n27b77f5473076563@mail.gmail.com>
In-Reply-To: <a4423d670904111946w2a8f3839n27b77f5473076563@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> 2009/4/9 Jeff Garzik <jeff@garzik.org>:
>> I reviewed and refreshed libata-dev.git#new-eh, now renamed to #sx4.
>>
>> Several bugs and missing pieces in the new-EH conversion were addressed
>> (often by copying highly similar code from sata_promise, a highly
>> similar chip)
>>
>> The only thing left is some "it still works" testing...  any takers?
>>
> 
> Hi Jeff
> 
> I have SX4000 card, it is based on the same PDC20621 chip, but has PATA ports
> (without PATA-SATA bridges).
> Can I help?
> 
> I am newbie here, but I will try to modify the driver to support PATA
> card as well
> and test your patch.

It's unknown how well, or what is needed, to support the SX4000.  You 
are welcome to dive in and figure out what is needed, but you'd be 
asking questions to which we wouldn't have answers.

	Jeff




