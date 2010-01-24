Return-Path: <linux-kernel-owner+w=401wt.eu-S1753734Ab0AXMOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab0AXMOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 07:14:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753705Ab0AXMON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 07:14:13 -0500
Received: from mail-gx0-f224.google.com ([209.85.217.224]:65411 "EHLO
	mail-gx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642Ab0AXMON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 07:14:13 -0500
X-Greylist: delayed 66101 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Jan 2010 07:14:13 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m3NO9ckdl0apS5jDcjlCG1pSg5/0EAS5KYoVt8Nk7+M/jdwDC/jh6hJFcQSovtjsMj
         bk56aakmPpq+G5feXHQZ7ylblq9Rtqme5xCMQC+SsBS8EOdQwB6ee97KhQj4+Vadlv6p
         P3mWNHROUKPxaYXNRuNbWV+aqr+pkxMtW2Y/g=
MIME-Version: 1.0
In-Reply-To: <20100124103019.6c6f23a6@hyperion.delvare>
References: <3f9a31f41001230952g6321c47bq9baf5dcfdfaf5b59@mail.gmail.com>
	 <20100124103019.6c6f23a6@hyperion.delvare>
Date: Sun, 24 Jan 2010 17:44:11 +0530
Message-ID: <3f9a31f41001240414x4c706181s64392c79be4c4141@mail.gmail.com>
Subject: Re: Status of Andigilog asc7621 driver submitted by George Joseph on 
	2008-05-29
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: George Joseph <George.joseph@fairview5.com>, lm-sensors@lm-sensors.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Hans de Goede <j.w.r.degoede@hhs.nl>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

On Sun, Jan 24, 2010 at 3:00 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sat, 23 Jan 2010 23:22:29 +0530, Jaswinder Singh Rajput wrote:
>> Andigilog asc7621 driver submitted by George Joseph on 2008-05-29,
>> This chip is used by various Intel Motherboards.
>>
>> Is it still under review and testing :
>>
>> http://lists.lm-sensors.org/pipermail/lm-sensors/2008-May/023257.html
>>
>> http://www.spinics.net/lists/lm-sensors/msg26915.html
>>
>> http://www.spinics.net/lists/lm-sensors/msg26916.html
>>
>> http://www.lm-sensors.org/wiki/Devices
>
> I've updated the wiki entry to point to the latest version of the
> driver. I've also included a complete list of known requests so far,
> which can be used to get in touch with potential testers.
>

Thanks for updating the wiki.

Latest asc7621 driver is giving compilation errors with latest kernel
git. Do you also also have plans to update the driver so that we can
use the asc7621 driver.

I am ready for testing and debugging it.

Thank you,
--
Jaswinder Singh.
