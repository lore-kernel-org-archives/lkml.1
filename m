Return-Path: <linux-kernel-owner+w=401wt.eu-S1750842AbXBWEEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750842AbXBWEEJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 23:04:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750848AbXBWEEJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 23:04:09 -0500
Received: from www.nabble.com ([72.21.53.35]:37094 "EHLO talk.nabble.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbXBWEEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 23:04:08 -0500
Message-ID: <9113207.post@talk.nabble.com>
Date: Thu, 22 Feb 2007 20:04:07 -0800 (PST)
From: pgf111000 <junkmail@petergfrazier.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Areca driver 2.6.19 on x86_64
In-Reply-To: <000301c719a9$70e4f8d0$2900a8c0@arecakevin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: junkmail@petergfrazier.com
References: <3193.213.203.144.13.1165423892.squirrel@mailserver.omnibit.it> <20061206230949.GA25461@brong.net> <000301c719a9$70e4f8d0$2900a8c0@arecakevin>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


These solutions are laughable....




Areca Support wrote:
> 
> Dear Sir,
> 
> This is Kevin Wang from Areca Technology, Tech-Support Team.
> regarding your problem, please trying to disable ACPI in kernel loader.
> if the problem happen as soon as driver loaded, it should be the IRQ
> releated issue.
> the motherboard bios didn't assigned a correct IRQ to controller, it makes
> the driver can't initialize controller.
> and in our experience, disable ACPI in kernel loader can solved this ussue
> in some distro.
> 
> 
> Best Regards,
> 
> 
> Kevin Wang
> 
> Areca Technology Tech-support Division
> Tel : 886-2-87974060 Ext. 223
> Fax : 886-2-87975970
> Http://www.areca.com.tw
> Ftp://ftp.areca.com.tw
> 
> ----- Original Message ----- 
> From: "Bron Gondwana" <brong@fastmail.fm>
> To: <filip@euroweb97.com>
> Cc: <support@areca.com.tw>; <linux-kernel@vger.kernel.org>;
> <erich@areca.com.tw>
> Sent: Thursday, December 07, 2006 7:09 AM
> Subject: Re: Areca driver 2.6.19 on x86_64
> 
> 
>> On Wed, Dec 06, 2006 at 05:51:32PM +0100, filip@euroweb97.com wrote:
>> > OS distro used:
>> > CentOS 4.4 x86_64
>> > Kernel 2.6.19 with hand-crafted config, that we are
>> > able to use successfully with kernel 2.6.16.20.
>>
>> What patches were you applying to 2.6.16.20, since that didn't
>> have an Areca driver in it I presume you're at least using that.
>>
>> > Have you any suggestions to resolve this issue ?
>>
>> 32 bit kernel?  I'm somewhat serious here, depending what applications
>> you're running on the machine.
>>
>> Otherwise, no clue sorry - we're running 32 bit kernels everywhere
>> even on the couple of new Core machines we have.
>>
>> Bron.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
View this message in context: http://www.nabble.com/Areca-driver-2.6.19-on-x86_64-tf2769326.html#a9113207
Sent from the linux-kernel mailing list archive at Nabble.com.

