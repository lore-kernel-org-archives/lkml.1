Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZIWCDF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZIWCDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 22:03:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753619AbZIWCDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 22:03:04 -0400
Received: from mail-qy0-f188.google.com ([209.85.221.188]:49138 "EHLO
	mail-qy0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753576AbZIWCDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 22:03:03 -0400
Message-ID: <4AB9819B.5070202@vflare.org>
Date: Wed, 23 Sep 2009 07:32:03 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ed Tomlinson <edt@aei.ca>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: TODO file for ramzswap
References: <d760cf2d0909220302h1d74915atde0f6fe3b0fb3d6c@mail.gmail.com> <200909222030.33261.edt@aei.ca>
In-Reply-To: <200909222030.33261.edt@aei.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2009 06:00 AM, Ed Tomlinson wrote:
> On Tuesday 22 September 2009 06:02:33 Nitin Gupta wrote:
>> TODO file for ramzswap.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>
>> ---
>>  drivers/staging/ramzswap/TODO |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/staging/ramzswap/TODO b/drivers/staging/ramzswap/TODO
>> new file mode 100644
>> index 0000000..bac40d6
>> --- /dev/null
>> +++ b/drivers/staging/ramzswap/TODO
>> @@ -0,0 +1,6 @@
>> +TODO:
>> +	- Add support for swap notifiers
>> +	- Remove CONFIG_ARM hack
> 
> Is locking still an issue with SMP?  If so, its probably a good item for the todo list.
> 

The scalability issue, runtime defragmentation etc. are more long term goals.
In todo list, I just wanted to include things that are needed to get it out of staging.

Thanks,
Nitin

