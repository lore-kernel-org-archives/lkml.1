Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbYEENMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbYEENMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 09:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754187AbYEENMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 09:12:12 -0400
Received: from ns.theshore.net ([67.18.92.50]:46972 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754029AbYEENML (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 09:12:11 -0400
Message-ID: <481F07A9.5060107@theshore.net>
Date: Mon, 05 May 2008 09:12:09 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: pvops - xen - unable to handle kernel paging request
References: <480CC04C.2020100@theshore.net> <480FCD33.5090303@goop.org> <4818F2A0.10402@goop.org>
In-Reply-To: <4818F2A0.10402@goop.org>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
 > Ping?

Whoops.  Been on holiday for the past few days.

>> How easy is this to reproduce?  Is this immediate or under load?

I'm not sure what the VM was doing when this was hit.  I'll open 2.6.25 
up for more testing and see what happens...

>> How much memory does the host machine have?  How much allocated to the 
>> domain?

24G on the host server.  300M allocated to dom0 and 360MB to domUs.

>> And to be clear, this is plain 2.6.25, not 2.6.25+mergewindow, right?

Correct -- no extra patches.

>> (BTW, it would help if you cc: me on Xen bug reports, since I don't 
>> necessarily catch up on lkml traffic very quickly.)

Not a problem (so many lists...)

-Chris
