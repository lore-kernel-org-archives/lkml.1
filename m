Return-Path: <linux-kernel-owner+w=401wt.eu-S1751946AbZHXHl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946AbZHXHl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 03:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbZHXHl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 03:41:26 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62576 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZHXHlZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 03:41:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=dHoIHZbmjnAFTSvgkgb5UqxjmFB2sXPvEmDX0H8T8NX+LoL9QRbdp7SKkp1oL9wVnU
         FNejzARxFlrUe3MmArmr9ivvFIS3ntBRMi4bYWO8KjitEclqTZxIZ6+TEzfQmPpF4QCE
         0NyoUul0m0CJYReb/tYzb7ZQJ4iNI3PbyzJ1Q=
MIME-Version: 1.0
In-Reply-To: <200908201652.23574.rjw@sisk.pl>
References: <xDf-7eSwYsC.A.-6B.klIjKB@chimera>
	 <Era7U-todKF.A.-rD.DoIjKB@chimera>
	 <38b2ab8a0908200038k2702109bp7e2d4b50e511d365@mail.gmail.com>
	 <200908201652.23574.rjw@sisk.pl>
Date: Mon, 24 Aug 2009 09:41:25 +0200
Message-ID: <38b2ab8a0908240041s7d9707eftb6e8078d7b6ad553@mail.gmail.com>
Subject: Re: [Bug #13328] b44: eth0: BUG! Timeout waiting for bit 00000002 of 
	register 42c to clear.
From: Francis Moreau <francis.moro@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 20, 2009 at 4:52 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
> On Thursday 20 August 2009, Francis Moreau wrote:
>> Hello,
>>
>> On Wed, Aug 19, 2009 at 10:40 PM, Rafael J. Wysocki<rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.29 and 2.6.30.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.29 and 2.6.30.  Please verify if it still should
>> > be listed and let me know (either way).
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=13328
>> > Subject         : b44: eth0: BUG! Timeout waiting for bit 00000002 of register 42c to clear.
>> > Submitter       : Francis Moreau <francis.moro@gmail.com>
>> > Date            : 2009-05-03 16:22 (109 days old)
>> > References      : http://marc.info/?l=linux-kernel&m=124136778012280&w=4
>> >
>>
>> It hasn't triggered on 2.6.31-rc5 after a couple of days.
>
> Great, let's assume it's fixed, then.

Sorry but it did happen this weekend.

-- 
Francis
