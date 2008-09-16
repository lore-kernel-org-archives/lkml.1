Return-Path: <linux-kernel-owner+w=401wt.eu-S1756574AbYIPDI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574AbYIPDI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 23:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753997AbYIPDIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 23:08:49 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:22576 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795AbYIPDIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 23:08:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=O+zu9/KMqrMySCA2LL37nc4MkntBKdOPor3SaEboQdQk30fqwnLzZo75OVfQZyj9g8
         B6Lh+VRdqEdG9SzbpThquPAHTJtoaZ6tfDLHPNfBYrGYwq7PKNqy0wdiEQU+NOwhGJBM
         6uALSUhHz6E0nOqZyUg3uPxAAs17WnGTu4AFM=
Message-ID: <dd18b0c30809152008p17cd7753l68ab2e562f08039c@mail.gmail.com>
Date: Mon, 15 Sep 2008 20:08:47 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Buffer I/O error on device sr0, logical block 793066
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48CF0D84.7060804@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.RthRteIKyDr2XSXrOGnYRXbkLXg@ifi.uio.no>
	 <48CF0D84.7060804@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2008 at 6:36 PM, Robert Hancock <hancockr@shaw.ca> wrote:
> Justin Mattock wrote:
>>
>> I guess russell crow doesnt have a problem with me(Gladiator), but
>> as soon as jodie foster is the main character(Panic Room);
>>  I receieve this:
>>
>>
>> [14417.951134] sr 0:0:0:0: [sr0] Result: hostbyte=DID_OK
>> driverbyte=DRIVER_SENSE,SUGGEST_OK
>> [14417.951150] sr 0:0:0:0: [sr0] Sense Key : Hardware Error [current]
>> [14417.951160] Info fld=0xc1a00
>> [14417.951163] sr 0:0:0:0: [sr0] Add. Sense: Track following error
>> [14417.951172] end_request: I/O error, dev sr0, sector 3172264
>
> "Track following error" comes right from the drive, it can't read the disc
> properly. Scratched perhaps?
>

That was weired, the dvd played probably
25% then all of a sudden freeze(only mplayer everything was fine);
then a reboot, then the dvd played all the way through without any issues.
I did a few days prior clean the lens on the disk drive, so maybe this
had something
todo with(can't see how), Maybe the lens is so clean, it can pickup on
scratches on the disk,
Anyways better to post when something like this occurs than not at all.
regards;

-- 
Justin P. Mattock
