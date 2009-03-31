Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZCaBJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZCaBJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 21:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754667AbZCaBI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 21:08:59 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:36294 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZCaBI6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 21:08:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sH5aNtg4SrZSUBXz7D4+f0LeQDgIwSXZiZPdH9X4eKYHokusNA2FAe8oP829VYkyyD
         kdO3Zv3gbDpGHxkLZ5BQZDehTvJdpHida3cysfl+r6i+uBkUHcmgHu3PSsMXi8YBiFTU
         nF9OFTsT45JmLm+0z/TXZgGMt0v5UmMbZtJ0w=
MIME-Version: 1.0
In-Reply-To: <1238407893.24972.30.camel@johannes.local>
References: <1238407355.24972.29.camel@johannes.local>
	 <1238407893.24972.30.camel@johannes.local>
Date: Mon, 30 Mar 2009 21:08:54 -0400
X-Google-Sender-Auth: 628d073258b48389
Message-ID: <a0c408570903301808k54a31f99m643b7197ee9557ba@mail.gmail.com>
Subject: Re: [PATCH] toshiba-acpi: remove MAINTAINERS entry
From: John Belmonte <john@neggie.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Len Brown <len.brown@intel.com>, Philip Langdale <philipl@overt.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Deliveries to toshiba_acpi@memebeam.org work fine as far as I can tell.

I'm not much opposed to marking this driver orphaned.  I haven't used
a Toshiba laptop in four years or so, and disagree with the recent
additions of bluetooth and wireless control to the driver.

--John


On Mon, Mar 30, 2009 at 6:11 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2009-03-30 at 12:02 +0200, Johannes Berg wrote:
>> The web server at memebeam.org refuses connections and the domain no
>> longer has an MX entry, so apparently John Belmonte has vanished.
>
> archive.org shows it's been that way for over a year, but turned up
> another email address, let's see if that works.
>
> johannes
>
>> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>>  MAINTAINERS |    5 +----
>>  1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> --- wireless-testing.orig/MAINTAINERS 2009-03-30 12:00:57.000000000 +0200
>> +++ wireless-testing/MAINTAINERS      2009-03-30 12:01:16.000000000 +0200
>> @@ -4294,10 +4294,7 @@ W:     http://sourceforge.net/projects/tlan/
>>  S:   Maintained
>>
>>  TOSHIBA ACPI EXTRAS DRIVER
>> -P:   John Belmonte
>> -M:   toshiba_acpi@memebeam.org
>> -W:   http://memebeam.org/toys/ToshibaAcpiDriver
>> -S:   Maintained
>> +S:   Orphan
>>
>>  TOSHIBA SMM DRIVER
>>  P:   Jonathan Buzzard
>>
>
