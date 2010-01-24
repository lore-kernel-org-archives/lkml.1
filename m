Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030Ab0AXH6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030Ab0AXH6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 02:58:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752926Ab0AXH6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 02:58:34 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:41977 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab0AXH6d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 02:58:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ASH+n5/4L0tFWe5xaGo906B9aLuMu+zT1AhkDqm4JsEct8Rjuy5chqwHXUBGqVyKvN
         pxFCYyf9TqV/16iWqAEDD50AABy9DDA3cVE2vWtwTVCpwkHJOVpi/ri2pIlj3sEXix1p
         ++Zm/bD2NshJ4Us1TI3CpWpdRTqtFuo3OUBeE=
MIME-Version: 1.0
In-Reply-To: <3f9a31f41001232223r4fc79debrd40c2987c11364c2@mail.gmail.com>
References: <3f9a31f41001230952g6321c47bq9baf5dcfdfaf5b59@mail.gmail.com>
	 <4B5B38C1.5080109@hhs.nl>
	 <3f9a31f41001232105l58d36ffdp8d06231f524a98ec@mail.gmail.com>
	 <f34ca13c1001232144t75ef8d1dqaffbe86b0c8407e7@mail.gmail.com>
	 <3f9a31f41001232223r4fc79debrd40c2987c11364c2@mail.gmail.com>
Date: Sun, 24 Jan 2010 02:58:32 -0500
Message-ID: <f34ca13c1001232358i37ee31e7g7ec72e121c906d80@mail.gmail.com>
Subject: Re: [lm-sensors] Status of Andigilog asc7621 driver submitted by 
	George Joseph on 2008-05-29
From: "Constantine A. Murenin" <mureninc@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Hans de Goede <j.w.r.degoede@hhs.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       lm-sensors@lm-sensors.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/1/24 Jaswinder Singh Rajput <jaswinderlinux@gmail.com>:
> Hello,
>
> On Sun, Jan 24, 2010 at 11:14 AM, Constantine A. Murenin
> <mureninc@gmail.com> wrote:
>> On 24/01/2010, Jaswinder Singh Rajput <jaswinderlinux@gmail.com> wrote:
>>> Many new Intel Motherboards are coming with this chip, if we complete
>>>  this driver then it will be great.
>>
>> Really?
>
> Yes, http://www.intel.com/products/server/motherboard/index.htm?iid=mbd_body+sv_all
>
>
> I have checked with Intel® Workstation Board WX58BP :

http://www.intel.com/support/motherboards/server/wx58bp/sb/CS-030316.htm
«
Spares, Parts List and Configuration Guide [PDF]
File Name: WX58BP Config Guide 1.0.pdf
Size: 76,709 bytes
Date: April 2009
File Revision: 1.0
»

The board seems old, or, at least, old enough to be designed when
Andigilog still existed. :-)


> Now follows a summary of the probes I have just done.
> Just press ENTER to continue:
>
> Driver `to-be-written':
>  * Bus `SMBus I801 adapter at 2000'
>    Busdriver `i2c_i801', I2C address 0x2e
>    Chip `Andigilog aSC7621' (confidence: 5)
>
> Driver `coretemp':
>  * Chip `Intel Core family thermal sensor' (confidence: 9)
>
> Note: there is no driver for Andigilog aSC7621 yet.
> Check http://www.lm-sensors.org/wiki/Devices for updates.
>
> Do you want to overwrite /etc/sysconfig/lm_sensors? (YES/no): YES
> Starting lm_sensors: loading module coretemp               [  OK  ]
> Unloading i2c-dev... OK
>
> You can also check with other intel motherboards.
>
>> My understanding was that the company, Andigilog, no longer
>> seem to exist since at least a couple of months ago (I don't recall
>> the exact dates their web-site was taken down without any notice, but
>> currently the domain has no information regarding semiconductors
>> whatsoever [0]).  It would therefore seem somewhat strange if Intel
>> was still using these chips in their recent designs — do you have some
>> concrete examples?  Anyone has any more details regarding Andigilog
>> and their products?
>>
>
> http://who.is/whois/andigilog.com/
>
> These motherboards are build in Taiwan, China. I have no idea that how
> they are getting these chips but you can see them in your latest Intel
> motherboards ;-)

Well, a better link would have been:

http://web.archive.org/web/*/http://www.andigilog.com/

:-)

C.
