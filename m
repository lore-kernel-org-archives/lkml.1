Return-Path: <linux-kernel-owner+w=401wt.eu-S1756376AbYJMIjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756376AbYJMIjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYJMIjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:39:32 -0400
Received: from hera.kernel.org ([140.211.167.34]:58813 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757510AbYJMIjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:39:31 -0400
Message-ID: <48F308E8.4030503@kernel.org>
Date: Mon, 13 Oct 2008 17:38:00 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <48DA0A2C.8010008@kernel.org> <48E890B9.6050307@gmail.com> <48E8947A.5020608@kernel.org> <48E89839.5030307@panasas.com> <48E899F9.9040206@kernel.org> <20081006211906.GA31148@anita.doom> <20081006212307.GA881@anita.doom> <48EAB535.8010203@kernel.org> <20081007060357.GA16761@anita.doom> <48EB1993.1030606@panasas.com> <20081008080848.GA20525@anita.doom> <48F3088C.9010002@kernel.org>
In-Reply-To: <48F3088C.9010002@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 13 Oct 2008 08:39:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Konstantin Kletschke wrote:
>> Am 2008-10-07 10:10 +0200 schrieb Benny Halevy:
>>
>>>> Then I switched off and smoked a cigarette, booting then lasted a bit longer:
>>> See, cigarettes are bad for you(r computer) ;-)
>> Yes... But where does he know from? I have no /dev/eyes still ;-)
>>
> 
> It has all the fans for a reason.  :-)
> 
> Eh... Joke aside.  I still don't know what's going on here.  Before
> 2.6.26, you always had clean boot, right?

Also, can you please repeat the test several times and see whether there
are some patterns?  And please also try pre-2.6.26 kernel a few times
just to make sure it's not some bad coincidence.

Thanks.

-- 
tejun
