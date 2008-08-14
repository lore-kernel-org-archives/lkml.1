Return-Path: <linux-kernel-owner+w=401wt.eu-S1758609AbYHNOKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758609AbYHNOKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 10:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752464AbYHNOKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 10:10:03 -0400
Received: from mx11.lb01.inode.at ([62.99.145.13]:19795 "EHLO mx.inode.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbYHNOKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 10:10:02 -0400
Message-ID: <48A43CB5.8010709@sbg.ac.at>
Date: Thu, 14 Aug 2008 16:09:57 +0200
From: Alexander Huemer <alexander.huemer@sbg.ac.at>
User-Agent: Thunderbird 2.0.0.16 (X11/20080729)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.27-rc1 mtrr fixes do not work
References: <4899AF8E.20105@sbg.ac.at> <200808072214.28922.rjw@sisk.pl>	 <7E82351C108FA840AB1866AC776AEC46092119D3@orsmsx505.amr.corp.intel.com>	 <86802c440808071323o3021a90rae51223187bfd47b@mail.gmail.com>	 <86802c440808071326m21cff146s3fb5e6118a58a2ca@mail.gmail.com>	 <489B73B7.4090705@sbg.ac.at>	 <86802c440808071616o23dde07atd694b45375f9d6ac@mail.gmail.com>	 <86802c440808071617i1344e595wb9cc7c2bf75a5b3f@mail.gmail.com>	 <489B85A3.7030500@sbg.ac.at> <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>
In-Reply-To: <86802c440808071658yd120d04y370859dcf5a7b759@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, Aug 7, 2008 at 4:30 PM, Alexander Huemer
> <alexander.huemer@sbg.ac.at> wrote:
>   
>> Yinghai Lu wrote:
>>     
>
>   
>>>> can you put "debug" in command line too?
>>>>
>>>>         
>>> without mtrr_chunk_size etc in command line...please
>>>
>>>       
>> http://xx.vu/~ahuemer/dmesg_3.txt
>>
>>     
>
> do you have
> CONFIG_MTRR=y
> CONFIG_MTRR_SANITIZER=y
> CONFIG_MTRR_SANITIZER_ENABLE_DEFAULT=1
> CONFIG_MTRR_SANITIZER_SPARE_REG_NR_DEFAULT=1
>
> in your .config?
>
> YH
>   
2.6.27_rc3 does not solve the problem either.
what can i do to help?

-- 
alex
