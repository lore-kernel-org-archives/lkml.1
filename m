Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYFAAzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYFAAzC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 20:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755160AbYFAAyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 20:54:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:13751 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbYFAAyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 20:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=H31grtKZk0sHpMtxET2LuOjqpElGJPH31MEW27/7n3+rbYuj3t1xeZ1JDhTAubR1dvLjO/cG21+gnr/KPEU3l8cTqgBq9I80aW2/OnIvca1Bll8MQy6RSpgArvNvnxvzSM+zEkDztgFTOA9scpz05izsjI0ZwzJ8VIdMWnDKros=
Message-ID: <86802c440805311754y6f8d56ckfa12aae308a82c5a@mail.gmail.com>
Date: Sat, 31 May 2008 17:54:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Gabriel C" <nix.or.die@googlemail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [Bug #10613] BIOS bug, APIC version is 0 for CPU#0!
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <4841F225.4050702@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <90LLR3uLHfN.A.NZC.LqZQIB@albercik>
	 <UJSav77TyUB.A.NYG.MuZQIB@albercik> <4841F225.4050702@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2008 at 5:49 PM, Gabriel C <nix.or.die@googlemail.com> wrote:
> Rafael J. Wysocki wrote:
>
>> This message has been generated automatically as a part of a report
>> of recent regressions.
>>
>> The following bug entry is on the current list of known regressions
>> from 2.6.25.  Please verify if it still should be listed.
>>
>>
>> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=10613
>> Subject               : BIOS bug, APIC version is 0 for CPU#0!
>> Submitter     : Gabriel C <nix.or.die@googlemail.com>
>> Date          : 2008-05-03 15:11 (29 days old)
>> References    : http://www.ussg.iu.edu/hypermail/linux/kernel/0805.0/1258.html
>> Handled-By    : Yinghai Lu <yhlu.kernel@gmail.com>
>> Patch         : http://lkml.org/lkml/2008/5/22/493
>>
>>
>
>
> Ohh I didn't saw that patch :|
>
> I try to find the time to test it tomorrow.

please use
http://lkml.org/lkml/2008/5/22/506
instead.

and it is in tip/x86/urgent

YH
