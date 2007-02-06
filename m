Return-Path: <linux-kernel-owner+w=401wt.eu-S1752267AbXBFRs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267AbXBFRs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 12:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752262AbXBFRs5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 12:48:57 -0500
Received: from mail.tmr.com ([64.65.253.246]:35209 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXBFRs4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 12:48:56 -0500
Message-ID: <45C8BF9A.2@tmr.com>
Date: Tue, 06 Feb 2007 12:49:14 -0500
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Robert Hancock <hancockr@shaw.ca>, Patrick Ale <patrick.ale@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: hdparm for lib_pata
References: <fa.L/RjDlo6Njb5Jt7/9ENZuiASoV0@ifi.uio.no> <45C4DF2A.1070501@shaw.ca> <45C77435.8090806@rtr.ca>
In-Reply-To: <45C77435.8090806@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> Robert Hancock wrote:
>> ..
>> Only some of the hdparm functionality is supported in libata,
> 
> That's not true.  MOST hdparm functionality is supported in libata.
> Only a very few things are not supported, including -d and -X,
> for reasons already pointed out.
> 
> Nearly everything else works.
> 
Agreed, I've already had problems typing faster than I think, twice, as 
as I hit ENTER saying "wait, that's a SCSI device" and then "wow, it 
worked anyway!" Nice job on the whole, but setting transfer modes is 
desirable, still.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
