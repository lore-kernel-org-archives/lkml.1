Return-Path: <linux-kernel-owner+w=401wt.eu-S1758569AbYHNRb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569AbYHNRb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 13:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751460AbYHNRbs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 13:31:48 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:32868 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751019AbYHNRbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 13:31:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=MxJWt4w0KfaZhlvDA19B/0MM47ZK2nzlSKxqHk2jeEsWDgKYAaRU2eXtjrrHqt+CsV
         by3OqOqWckt8UTXNkMC9q87NOiqIDDbAoPGOIw2f9W8Ep6ReAo4R76KmNNJkk/VT7Xqg
         /Jp32QCewqOqnTYAucbPHgI1FyARYO0NenJ40=
Message-ID: <86802c440808141031p2712976cqe2c34d3b986ad810@mail.gmail.com>
Date: Thu, 14 Aug 2008 10:31:45 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Alexander Huemer" <alexander.huemer@sbg.ac.at>
Subject: Re: 2.6.27-rc1 mtrr fixes do not work
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <andi@firstfloor.org>
In-Reply-To: <48A43CB5.8010709@sbg.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4899AF8E.20105@sbg.ac.at>
	 <7E82351C108FA840AB1866AC776AEC46092119D3@orsmsx505.amr.corp.intel.com>
	 <86802c440808071323o3021a90rae51223187bfd47b@mail.gmail.com>
	 <86802c440808071326m21cff146s3fb5e6118a58a2ca@mail.gmail.com>
	 <489B73B7.4090705@sbg.ac.at>
	 <86802c440808071616o23dde07atd694b45375f9d6ac@mail.gmail.com>
	 <86802c440808071617i1344e595wb9cc7c2bf75a5b3f@mail.gmail.com>
	 <489B85A3.7030500@sbg.ac.at>
	 <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>
	 <48A43CB5.8010709@sbg.ac.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 7:09 AM, Alexander Huemer
<alexander.huemer@sbg.ac.at> wrote:
> Yinghai Lu wrote:
>>
>> On Thu, Aug 7, 2008 at 4:30 PM, Alexander Huemer
>> <alexander.huemer@sbg.ac.at> wrote:
>>
>>>
>>> Yinghai Lu wrote:
>>>
>>
>>
>>>>>
>>>>> can you put "debug" in command line too?
>>>>>
>>>>>
>>>>
>>>> without mtrr_chunk_size etc in command line...please
>>>>
>>>>
>>>
>>> http://xx.vu/~ahuemer/dmesg_3.txt
>>>
>>>
>>
>> do you have
>> CONFIG_MTRR=y
>> CONFIG_MTRR_SANITIZER=y
>> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
>> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>>
>> in your .config?
>>
>> YH
>>
>
> 2.6.27_rc3 does not solve the problem either.
> what can i do to help?

please send out you config

YH
