Return-Path: <linux-kernel-owner+w=401wt.eu-S966225AbXDDBQu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966225AbXDDBQu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:16:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966229AbXDDBQu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:16:50 -0400
Received: from [202.78.101.198] ([202.78.101.198]:35548 "EHLO mail.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966225AbXDDBQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:16:48 -0400
Message-ID: <4612FC57.2060207@gmail.com>
Date: Wed, 04 Apr 2007 09:16:07 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel source dependency
References: <46120EBE.8080705@gmail.com> <20070403081853.6590ef84.randy.dunlap@oracle.com>
In-Reply-To: <20070403081853.6590ef84.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Tue, 03 Apr 2007 16:22:22 +0800 Carlo Florendo wrote:
> 
>> Hello,
>>
>> I'm not sure whether a fix is necessary for the following scenario.
>>
>> The kernel configure target "make menuconfig" requires ncurses.   FWIW, it
>> could probably be better if the error message would indicate that that
>> ncurses is necessary for "make menuconfig" to run and that the user could
>> be prompted to install the package.
> 
> Hi,
> Without ncurses installed, you should see these messages:
> 
> 	echo " *** Unable to find the ncurses libraries."
> 	echo " *** make menuconfig require the ncurses libraries"
> 	echo " *** "
> 	echo " *** Install ncurses (ncurses-devel) and try again"
> 	echo " *** "
> 
> Do you not see them?  or do you need something different?

Thanks. It seems I just made noise.   I saw exactly the same thing you 
posted, now that I've rested and it's 9:30AM.  I didn't see it the other 
day at 2:30AM.  Maybe I need more sleep :)

Thank you very much.

Best Regards,

Carlo



-- 
Carlo Florendo
Softare Engineer/Network Co-Administrator
Astra Philippines Inc.
UP-Ayala Technopark, Diliman 1101, Quezon City
Philippines
http://www.astra.ph

--
The Astra Group of Companies
5-3-11 Sekido, Tama City
Tokyo 206-0011, Japan
http://www.astra.co.jp
