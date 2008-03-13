Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbYCMOht@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbYCMOht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 10:37:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752542AbYCMOhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 10:37:41 -0400
Received: from el-out-1112.google.com ([209.85.162.182]:5176 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbYCMOhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 10:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=gwW5e8jpiuAfhlj+vuAAcOhpTjqdg6ovBWP8i85rvgsEGIKwf/f6Z/3TpduoApSohFfIv4MwNV+axLorj5HgeII8QxJd9Q/kY/Nlq22q1gDE55IyP3GacH4ItNvfbtXTF4hzz0ba/JMMYHIQexXfUKumgI/jKrBeImjYWkxzQ+Y=
Message-ID: <47D93C2C.8040907@gmail.com>
Date: Thu, 13 Mar 2008 17:37:32 +0300
From: Alexey Starikovskiy <aystarik@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Lukas Hejtmanek <xhejtman@ics.muni.cz>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Arkadiusz Miskiewicz <arekm@maven.pl>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
Subject: Re: 2.6.25-rc2 Regression Thinkpad acpi
References: <20080312135521.GE8141@ics.muni.cz> <200803121952.42666.arekm@maven.pl> <20080312193637.GA27873@ics.muni.cz> <20080312211306.GD30864@khazad-dum.debian.net> <20080313120514.GH17940@kernel.dk> <20080313122344.GD27873@ics.muni.cz> <20080313124633.GS17940@kernel.dk> <20080313125503.GE27873@ics.muni.cz> <20080313125933.GT17940@kernel.dk> <20080313130934.GG27873@ics.muni.cz> <20080313131334.GV17940@kernel.dk>
In-Reply-To: <20080313131334.GV17940@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Mar 13 2008, Lukas Hejtmanek wrote:
>   
>> On Thu, Mar 13, 2008 at 01:59:34PM +0100, Jens Axboe wrote:
>>     
>>> The BIOS isn't that old, probably updated it a couple of months ago.
>>>       
>> I use the latest BIOS for my T61 and it just works. At least the event is
>> generated either for acpid or for Xserver.
>>     
>
> This is an x60, so there may be other differences there.
>
>   
There are was some playing with acpi_osi=Linux in this timeframe, known
to deal with sound buttons too.
Some of Thinkpads were inserted into the blacklist to need this OSI.
It might be that your Thinkpad needs it too...

Regards,
Alex.
