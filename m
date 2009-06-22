Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbZFVSpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbZFVSpp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbZFVSpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:45:38 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:56915 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbZFVSph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PNyxruoPxqmW6rkSLE4KPW/wlA4ATOFBCBfDHKFmg2uhq1eIhCONlM7zcu9o8FQe1f
         rleY/p/bhjeCvYzgum1byTgiPVgQLR11JFgLeQKrgPIh7Qy922hFi7p5DcraIfyiHRcq
         w5yKrafEH9xvca4i7j5hnc4vM3/2dwacns63k=
MIME-Version: 1.0
In-Reply-To: <200906222041.06103.rjw@sisk.pl>
References: <8db1092f0906211002y2b391212ve2902fc3a6517586@mail.gmail.com>
	 <8db1092f0906221037m30c7966bx6870b4eeb9ee16ea@mail.gmail.com>
	 <8db1092f0906221112y241abc19nb2b0a4a75ef253b4@mail.gmail.com>
	 <200906222041.06103.rjw@sisk.pl>
Date: Mon, 22 Jun 2009 20:45:37 +0200
Message-ID: <8db1092f0906221145w3c5113edp1eec1368dcc11f33@mail.gmail.com>
Subject: Re: 2.6.30-git(16 and 17) system hangs after resume from suspend to 
	disk, mce related?
From: Maciej Rutecki <maciej.rutecki@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andi Kleen <ak@linux.intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/6/22 Rafael J. Wysocki <rjw@sisk.pl>:
> On Monday 22 June 2009, Maciej Rutecki wrote:
>> 2009/6/22 Maciej Rutecki <maciej.rutecki@gmail.com>:
>>
>> > I already do this test:
>> > 1. boot, check_interval=0*
>> > 2. suspend to disk
>> > 3. wait 10 minutes
>> > 4. resume
>> 5. After resume uptime shows 15 minutes
>> 6. wait 15 minutes; nothing happen
>
> Does it mean the box survived the test?

Yes.


> Before 2. in your procedure run 'echo core > /sys/power/pm_test'.  It will not

I will check.

Regards
-- 
Maciej Rutecki
http://www.maciek.unixy.pl
