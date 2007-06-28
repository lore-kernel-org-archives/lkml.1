Return-Path: <linux-kernel-owner+w=401wt.eu-S932458AbXF1WxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932458AbXF1WxY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 18:53:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763913AbXF1WxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 18:53:16 -0400
Received: from mail.tmr.com ([64.65.253.246]:44912 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757619AbXF1WxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 18:53:16 -0400
Message-ID: <46843C4E.2020405@tmr.com>
Date: Thu, 28 Jun 2007 18:55:10 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Andi Kleen <andi@firstfloor.org>,
       Daniel J Blueman <daniel.blueman@gmail.com>,
       Shaohua Li <shaohua.li@intel.com>, jamagallon@ono.com,
       tigran@aivazian.fsnet.co.uk,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: New format Intel microcode...
References: <6278d2220703221645j760a8816v4b8749ea2d60e493@mail.gmail.com> <1174610594.6598.3.camel@sli10-conroe.sh.intel.com> <6278d2220706261442u9b137c5xb6225b3f56605554@mail.gmail.com> <p731wfy5m74.fsf@bingen.suse.de> <4683BD56.7070707@tmr.com> <20070628152747.GA14519@one.firstfloor.org> <4683D762.7070609@redhat.com>
In-Reply-To: <4683D762.7070609@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 06/28/2007 11:27 AM, Andi Kleen wrote:
>> But the problem is very obscure and you can likely ignore it too. If your 
>> machine crashes it's very likely something else.
> 
> What about deliberate exploits of these bugs from userspace? Theo thinks
> they are possible...
> 
Do you have any details? One of the folks in a chat was saying something 
similar, but thought that causing as crash was the extent of it, rather 
than any access violation. Obviously I don't know the extent of that 
claim, so more information would be good.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
