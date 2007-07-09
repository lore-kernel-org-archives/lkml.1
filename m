Return-Path: <linux-kernel-owner+w=401wt.eu-S1758488AbXGIRvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758488AbXGIRvS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 13:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753972AbXGIRvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 13:51:11 -0400
Received: from mail.tmr.com ([64.65.253.246]:34945 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625AbXGIRvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 13:51:10 -0400
Message-ID: <46927679.9020005@tmr.com>
Date: Mon, 09 Jul 2007 13:55:05 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: Liunx power consumption on laptops -- Enormous progress in the
   last few months
References: <468D4D82.8030009@linux.intel.com> <468E6F0C.1090601@redhat.com> <468E6F4C.8000601@linux.intel.com> <468E83CE.8090800@redhat.com>
In-Reply-To: <468E83CE.8090800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On 07/06/2007 12:35 PM, Arjan van de Ven wrote:
>>> Where is the ondemand-fix.patch? I can't find any link to it.
>> just click on it in the graph ;_
>>
>> it's also http://www.linuxpowertop.org/patches/ondemand-fix.patch (which
>> is submitted already to the maintainers)
>>
> 
> Ah, OK, that one just went into the latest Fedora 7 kernel.
> 
All this information makes it obvious that even though upgrades are 
painful (given slow laptop disks, *really* painful), it looks as if 
there are major benefits to be gained.

Thanks for sharing the information.

As improved as USB drivers are, I assume that unloading the drivers is 
still desirable if no USB hardware is in use.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
