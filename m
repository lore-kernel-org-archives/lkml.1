Return-Path: <linux-kernel-owner+w=401wt.eu-S1762993AbXFJIh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762993AbXFJIh5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 04:37:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762780AbXFJIhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 04:37:51 -0400
Received: from smtpgw02.netonehosting.com ([193.192.98.26]:50736 "EHLO
	smtpgw02.netonehosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762800AbXFJIhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 04:37:50 -0400
Message-ID: <466BB85B.6050703@netone.net.tr>
Date: Sun, 10 Jun 2007 11:37:47 +0300
From: Tarkan Erimer <tarkan@netone.net.tr>
User-Agent: Thunderbird 2.0.0.0 (Windows/20070326)
MIME-Version: 1.0
To: davids@webmaster.com
CC: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKAEFCEHAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKAEFCEHAC.davids@webmaster.com>
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit
X-NETONE-MailScanner-Information: Please contact the ISP for more information
X-NETONE-MailScanner: Found to be clean
X-NETONE-MailScanner-From: tarkan@netone.net.tr
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

David Schwartz wrote:
>> But; if the Linux kernel should Dual-Licensed (GPL V2 and GPL V3), it
>> will allow us the both worlds' fruits like code exchanging from other
>> Open Source Projects (OpenSolaris etc.) that is compatible with GPL V3
>> and not with GPL V2 and of course the opposite is applicable,too.
>>     
>
> That is a misleading claim. While being dual-licensed would make it either
> for other projects to adopt Linux code, it would have three downsides:
>
> 1) If Linux code were adopted into other projects that were not
> dual-licensed, changes could not be imported back into Linux unless the
> changes were dual-licensed which is not likely when the contributions are
> made to a project that's not dual-licensed.
>
> 2) Linux could no longer take code from other projects that are GPL v2
> licensed unless it could obtain them under a dual license.
>
> And, last and probably most serious:
>
> 3) Linux derivatives could be available with just a GPL v3 license and no
> GPL v2. license if the derivers wanted things that way.
>
>   

Thanks for the corrections ;-) The whole picture is more clear now for 
me :-)
BTW,I found a really interesting blog entry about which code in Linux 
Kernel is using which version of GPL :

http://6thsenseless.blogspot.com/2007/02/how-much-linux-kernel-code-is-gpl-2.html

The work done on a Linux 2.6.20. The result is quite interesting. 
Because almost half  (Around %60 of the code licensed under "GPLv2 Only" 
and the rest is "GPLv2 or above","GPL-Version not specified,others that 
have not stated which and what version of License has been used) of the 
code is "GPLv2 or above" licensed. And also stated in the article that 
some of the codes should be "Dual Licensed" not the whole Linux kernel 
needed to be "Dual Licensed". So,if it is really like this, maybe we can 
make,for example: "File system related Codes", "Dual Licensed" and it 
will allow us to port ZFS from OpenSolaris requested by a lot of people 
or other things maybe ?





