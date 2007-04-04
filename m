Return-Path: <linux-kernel-owner+w=401wt.eu-S966233AbXDDBWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966233AbXDDBWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:22:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966236AbXDDBWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:22:00 -0400
Received: from [202.78.101.198] ([202.78.101.198]:35551 "EHLO mail.hq.astra.ph"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S966233AbXDDBV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:21:59 -0400
Message-ID: <4612FD8F.6080103@gmail.com>
Date: Wed, 04 Apr 2007 09:21:19 +0800
From: Carlo Florendo <subscribermail@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: kernel source dependency
References: <46120EBE.8080705@gmail.com> <20070403081853.6590ef84.randy.dunlap@oracle.com> <Pine.LNX.4.61.0704031846330.10155@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704031846330.10155@yvahk01.tjqt.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Apr 3 2007 08:18, Randy Dunlap wrote:
>> Hi,
>> Without ncurses installed, you should see these messages:
>>
>> 	echo " *** Unable to find the ncurses libraries."
>> 	echo " *** make menuconfig require the ncurses libraries"
>> 	echo " *** "
>> 	echo " *** Install ncurses (ncurses-devel) and try again"
>> 	echo " *** "
>>
>> Do you not see them?  or do you need something different?
> 
> Perhaps libreadline-devel? Though ncurses-devel will *most likely* have a
> dependency on that, more even than the kernel does on ncurses-devel ;-)

That is not so :)  The kernel-source's 'menuconfig' target does not need 
libreadline-devel.  Besides, there is no readline functionality that is 
evident at menuconfig.  Menu navigation is entirely done by ncurses calls.

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
