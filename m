Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253AbZD2NiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253AbZD2NiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 09:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751757AbZD2NiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 09:38:10 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:50351 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341AbZD2NiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 09:38:09 -0400
MIME-Version: 1.0
In-Reply-To: <49F801AF.1060404@246tNt.com>
References: <20090428165015.1410.47926.stgit@localhost.localdomain> 
	<49F801AF.1060404@246tNt.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 29 Apr 2009 07:37:48 -0600
Message-ID: <fa686aa40904290637g6a28e941p806b35e919f65270@mail.gmail.com>
Subject: Re: [PATCH] powerpc: Update MPC5xxx and Xilinx Virtex maintainer 
	entries
To: Sylvain Munaut <tnt@246tnt.com>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 1:28 AM, Sylvain Munaut <tnt@246tnt.com> wrote:
> Grant Likely wrote:
>> From: Grant Likely <grant.likely@secretlab.ca>
>>
>> - Add git tree URLs
>> - Drop Sylvain from the 5xxx maintainers list.  He hasn't been active
>>   for a while now.
>>
>> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
>
> Confirmed.

Thanks Sylvain.

g.

>
>> ---
>>
>>  MAINTAINERS |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>>
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index ef03abe..4a8d367 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -3434,11 +3434,10 @@ L:    linuxppc-dev@ozlabs.org
>>  S:   Maintained
>>
>>  LINUX FOR POWERPC EMBEDDED MPC5XXX
>> -P:   Sylvain Munaut
>> -M:   tnt@246tNt.com
>>  P:   Grant Likely
>>  M:   grant.likely@secretlab.ca
>>  L:   linuxppc-dev@ozlabs.org
>> +T:   git git://git.secretlab.ca/git/linux-2.6.git
>>  S:   Maintained
>>
>>  LINUX FOR POWERPC EMBEDDED PPC4XX
>> @@ -3456,6 +3455,7 @@ P:      Grant Likely
>>  M:   grant.likely@secretlab.ca
>>  W:   http://wiki.secretlab.ca/index.php/Linux_on_Xilinx_Virtex
>>  L:   linuxppc-dev@ozlabs.org
>> +T:   git git://git.secretlab.ca/git/linux-2.6.git
>>  S:   Maintained
>>
>>  LINUX FOR POWERPC EMBEDDED PPC8XX
>>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
