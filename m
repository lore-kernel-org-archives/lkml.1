Return-Path: <linux-kernel-owner+w=401wt.eu-S1755065Ab0A0Uq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab0A0Uq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 15:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942Ab0A0UqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 15:46:25 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:12954 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754936Ab0A0UqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 15:46:24 -0500
Message-ID: <4B60A54D.5060006@caviumnetworks.com>
Date: Wed, 27 Jan 2010 12:42:53 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joel Schopp <jschopp@austin.ibm.com>
CC: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, apw@canonical.com,
       davej@redhat.com
Subject: Re: [PATCH] checkpatch.pl: remove the 80 charactes punch card limit
References: <1264597747.3607.29.camel@wall-e> <4B6080C5.7020306@austin.ibm.com> <4B608D78.4040606@caviumnetworks.com> <4B60A288.2010909@austin.ibm.com>
In-Reply-To: <4B60A288.2010909@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jan 2010 20:42:53.0651 (UTC) FILETIME=[4C879A30:01CA9F91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joel Schopp wrote:
> 
>>>
>>>
>>> While the origins of 80 character lines dates back to punchcards 
>>> there is a reason it has survived the test of time.
>>
>> Has it though?  If that were the undisputed truth, we wouldn't be 
>> having this discussion.
> 
> If you know of a usability study that quantifies the effect of line 
> length on readibility of C code I'm willing to listen, and I'm sure 
> others are too.


Good point.  As with most things related to kernel development, a 
usability study or other market research from a reputable institution is 
a vital first step before taking any action.

We don't have any good peer reviewed research on the subject that I am 
aware of.  I guess even contemplating a change at this early point would 
be rash and dangerous.

I withdraw my previous comments with respect to the 80 Column Question. 
  Instead I would recommend elevating the WARNING to ERROR status.


David Daney
