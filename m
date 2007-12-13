Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbXLMIoA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbXLMIoA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:44:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbXLMInv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:43:51 -0500
Received: from il.qumranet.com ([82.166.9.18]:44425 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750792AbXLMInu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:43:50 -0500
Message-ID: <4760F0C4.3030604@qumranet.com>
Date: Thu, 13 Dec 2007 10:43:48 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Norbert Preining <preining@logic.at>
CC: Peter Zijlstra <peterz@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       hugh <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kernel BUG: Eeek! page_mapcount(page) went negative!
References: <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <20071210112135.GA19783@gamma.logic.tuwien.ac.at> <200712102230.04342.rjw@sisk.pl> <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <20071210112135.GA19783@gamma.logic.tuwien.ac.at> <475D37CE.8040602@qumranet.com> <20071210125938.GC25518@gamma.logic.tuwien.ac.at> <475D475A.8090007@qumranet.com> <20071210104859.GI7003@gamma.logic.tuwien.ac.at> <1197285967.31440.22.camel@twins> <20071212064730.GI26785@gamma.logic.tuwien.ac.at>
In-Reply-To: <20071212064730.GI26785@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Norbert Preining wrote:
> Hi all!
>
> On Mo, 10 Dez 2007, Peter Zijlstra wrote:
>   
>> How reproducable is this? You make it sound like its easy to reproduce,
>>     
>
> I tried and re-tried and re-tried to reproduce this, without success.
> Sorry. 
>
> I guess we can forget that one and assume that it was a strange
> coincidence.
>
> Sorry for the noise.
>   

There were some similar reports a while back, so this may not be noise.  
Please report if it happens again.

-- 
error compiling committee.c: too many arguments to function

