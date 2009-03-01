Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZCAKo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZCAKo1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 05:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZCAKoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 05:44:15 -0500
Received: from mail-ew0-f177.google.com ([209.85.219.177]:59636 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZCAKoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 05:44:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Tjc3z5WQIG2doOBnENUh8N2gJctrzcMClwjDiTk1qezoJ4GV/3XDeznGJQ/skrKCTS
         pEnaAw8W9OzGOXaJc7IRC25AYf7JRSf5Xg28+OAmG252l8AWL3ox/uquPd6cjyf0/VEH
         Rvj4/wFeULNGhIcRHEFROPzhuAEa/EczW30ps=
Message-ID: <49AA66CE.7080506@panasas.com>
Date: Sun, 01 Mar 2009 12:43:26 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       jeff@garzik.org, linux-kernel@vger.kernel.org, avishay@gmail.com,
       osd-dev@open-osd.org, jens.axboe@oracle.com,
       linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [osd-dev] [PATCH 1/8] exofs: Kbuild, Headers and osd utils
References: <49993FF2.9050200@panasas.com>	<20090217092042C.fujita.tomonori@lab.ntt.co.jp>	<499A70E7.4000405@panasas.com> <20090227170931Z.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090227170931Z.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Tue, 17 Feb 2009 10:10:15 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> FUJITA Tomonori wrote:
>>> Can you stop the argument, "exofs is similar to the existing
>>> traditional file systems hence it should be treated equally". It's
>>> simply untrue. Does anyone except for panasas people insist the same
>>> argument?
>>>
>> No I will not, it is true. exofs is just a regular old filesystem
>> nothing different.
> 
> After reading this, I gave up discussing this issue with you but I
> still wait for your fixes that you promised:
> 
> http://marc.info/?l=linux-scsi&m=123445759718253&w=2
> 
> 
> Thanks,
> --

They are on the way, I have not forgotten

Boaz

