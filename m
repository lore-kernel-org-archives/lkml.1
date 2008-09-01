Return-Path: <linux-kernel-owner+w=401wt.eu-S1755508AbYIAQa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508AbYIAQa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 12:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYIAQaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 12:30:16 -0400
Received: from mx1.renzel.net ([195.243.213.130]:52150 "EHLO
	nijmegen.renzel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbYIAQaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 12:30:14 -0400
X-Greylist: delayed 404 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Sep 2008 12:30:14 EDT
Message-ID: <48BC16E3.20500@linuxtv.org>
Date: Mon, 01 Sep 2008 18:22:59 +0200
From: Marcel Siegert <mws@linuxtv.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@infradead.org>
CC: Manu Abraham <abraham.manu@gmail.com>, v4l-dvb-maintainer@linuxtv.org,
       linux-dvb@linuxtv.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [linux-dvb] Merge multiproto tree
References: <48B9360D.7030303@gmail.com> <20080901120601.044ddc30@mchehab.chehab.org>
In-Reply-To: <20080901120601.044ddc30@mchehab.chehab.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hello mauro,

Mauro Carvalho Chehab schrieb:
> Hello, Manu,
> 
> On Sat, 30 Aug 2008, Manu Abraham wrote:
> 
>>  Hello Mauro,
>>
>>  Please pull from http://jusst.de/hg/multiproto_api_merge/
>>  to merge the following Changesets from the multiproto tree.
> 
> The need for supporting newer DTV protocols increases day by day, since when
> the first multiproto proposal started to be discussed, about two years ago.
> 
> At the end of the last year, Steven send one email to the ML with a different 
> API proposal. Yet, people decided to wait for your work to be done. People then 
> pinged you, from time to time, asking about the completion of multiproto. All 
> the times, your answer were that multiproto were not ready yet for production.
> 
how is the actual state of his proposal? 

> I'm aware that your solution seems to be more code-complete than Steven's 
> proposal.

> 
> But the recent activity on the mailing list regarding his idea (and its, 
> so far, positive feedback) and the fact that I was anyway planning to 
> have a discussion about the future of the DVB-API at the Linux Plumbers 
> Conference 2008 are supporting me in my idea of post-poning such a pull to 
> a point in time shortly after this event.
with whom? the linuxtv developers or with an attending audience?

i havent been on the list and that active since the "nearly two years war" begun,
thus i am not the one to ack or nack in this pull request.

what i did in the past was just watching what was happening and what was taking
progress - even if it is slow. 

users on the linuxtv list started to ask over and over again, when multiproto is
going to be merged. vdr started to support it in a kind of experiment.

due to the lack of spare time and devices :) i do not actually know how productive 
the vdr multiproto implementation is, but we should not start the whole discussions again.

if we do not merge multiproto now, we will never do it, i am afraid. 

for the future of this project it is more than neccessary to get some progress.

if there are no serious objections to multiproto, mauro, please pull/merge it 
within the next few days. to wait until the end of september is time spending without
any sense.

regards
marcel



 
> Cheers,
> Mauro
> 
> _______________________________________________
> linux-dvb mailing list
> linux-dvb@linuxtv.org
> http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
> 

