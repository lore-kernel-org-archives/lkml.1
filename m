Return-Path: <linux-kernel-owner+w=401wt.eu-S1755862AbYCCXv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbYCCXv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbYCCXvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:51:45 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:33020 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYCCXvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:51:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding:from;
        b=HbM0ta/HDk6mOsxO3pnLD5dTbx+ozb6u18emanHr2/HdvE5x1MwAgjeQsAxtWSc41wkZhbWlVtJmQ9/48SQJoiqZJ4vkEH5I6Uvd5asBb+XHJmhqmByVgo1SAxsoKyXI56WRGFVO0RFLrLNb2yEhbQLkXRl/JcFobGg83pVv70I=
Message-ID: <47CC8C0C.9080502@gmail.com>
Date: Tue, 04 Mar 2008 08:38:52 +0900
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org
Subject: Re: [patch 12/21] No Reclaim LRU Infrastructure
References: <20080228192908.126720629@redhat.com>	<20080228192929.031646681@redhat.com>	<44c63dc40802282058h67f7597bvb614575f06c62e2c@mail.gmail.com>	<1204296534.5311.8.camel@localhost>	<44c63dc40803021904n5de681datba400e08079c152d@mail.gmail.com> <20080303134634.5893b5e0@cuia.boston.redhat.com>
In-Reply-To: <20080303134634.5893b5e0@cuia.boston.redhat.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
From: "barrioskmc@gmail" <minchan.kim@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel wrote:
> On Mon, 3 Mar 2008 12:04:14 +0900
> "minchan Kim" <barrioskmc@gmail.com> wrote:
> 
>> One more thing.
>>
>> zoneinfo_show_print fail to show right information.
>> That's why 'enum zone_stat_item' and 'vmstat_text' index didn't matched.
>> This is a problem about CONFIG_NORECLAIM, too.
> 
> In what configuration do they not line up, and why?
> 
> AFAICS the #ifdefs in zone_stat_item and vmstat_text match up...
> 

So sorry, It was my mistake.
I seem to have a bad eye :(

Thanks,
barrios
