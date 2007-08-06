Return-Path: <linux-kernel-owner+w=401wt.eu-S1761033AbXHFCOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761033AbXHFCOw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 22:14:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752964AbXHFCOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 22:14:44 -0400
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:36367 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752710AbXHFCOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 22:14:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=WztGORQyJpGmAx0Kh2kLMGt70Z0d+ZPLwXN/AlxLXCmebIUzM+dr3BM6AjnbTp0zc9XwTjbRNqG5AzWUKudxFq1+tIzy83N/ArxhHYMM9MHrOttgA+LUe5XH+uAygBRazqjBKPIhz4DcUacA5/y63wZfMsI3FH0rg6fyXUVOhz8=  ;
X-YMail-OSG: crJtOm4VM1lUB_KLmG969lE1hdgK3orMRDx9XOsUh7cxudTpALYf02CoFRB2MEECfTruV8pUPA--
Message-ID: <46B6840B.8080006@yahoo.com.au>
Date: Mon, 06 Aug 2007 12:14:35 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: david@lang.hm
CC: Rene Herman <rene.herman@gmail.com>, Daniel Hazelton <dhazelton@enter.net>,
       Mike Galbraith <efault@gmx.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Frank Kingswood <frank@kingswood-consulting.co.uk>,
       Andi Kleen <andi@firstfloor.org>, Ray Lee <ray-lk@madrabbit.org>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Paul Jackson <pj@sgi.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: RFT: updatedb "morning after" problem [was: Re: -mm merge plans
 for 2.6.23]
References: <9a8748490707231608h453eefffx68b9c391897aba70@mail.gmail.com> <20070727030040.0ea97ff7.akpm@linux-foundation.org> <1185531918.8799.17.camel@Homer.simpson.net> <200707271345.55187.dhazelton@enter.net> <46AA3680.4010508@gmail.com> <Pine.LNX.4.64.0707271239300.26221@asgard.lang.hm> <46AAEDEB.7040003@gmail.com> <Pine.LNX.4.64.0707280138370.32476@asgard.lang.hm> <46AB166A.2000300@gmail.com> <Pine.LNX.4.64.0707281349540.32476@asgard.lang.hm> <46AC6771.8080000@gmail.com> <Pine.LNX.4.64.0707290420250.15835@asgard.lang.hm> <46AC9DC5.8070900@gmail.com> <Pine.LNX.4.64.0707291405350.15835@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707291405350.15835@asgard.lang.hm>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> On Sun, 29 Jul 2007, Rene Herman wrote:
> 
>> On 07/29/2007 01:41 PM, david@lang.hm wrote:
>>
>>>  I agree that tinkering with the core VM code should not be done 
>>> lightly,
>>>  but this has been put through the proper process and is stalled with no
>>>  hints on how to move forward.
>>
>>
>> It has not. Concerns that were raised (by specifically Nick Piggin) 
>> weren't being addressed.
> 
> 
> I may have missed them, but what I saw from him weren't specific issues, 
> but instead a nebulous 'something better may come along later'

Something better, ie. the problems with page reclaim being fixed.
Why is that nebulous?

-- 
SUSE Labs, Novell Inc.
