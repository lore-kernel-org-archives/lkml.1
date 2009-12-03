Return-Path: <linux-kernel-owner+w=401wt.eu-S1754064AbZLCWW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064AbZLCWW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 17:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZLCWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 17:22:28 -0500
Received: from xenotime.net ([72.52.64.118]:49865 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753707AbZLCWW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 17:22:27 -0500
Message-ID: <4B182C25.9070008@xenotime.net>
Date: Thu, 03 Dec 2009 13:22:45 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, yehuda@newdream.net
Subject: Re: ceph code review
References: <1253641129-28434-1-git-send-email-sage@newdream.net>	<1253641129-28434-2-git-send-email-sage@newdream.net>	<1253641129-28434-3-git-send-email-sage@newdream.net>	<1253641129-28434-4-git-send-email-sage@newdream.net>	<1253641129-28434-5-git-send-email-sage@newdream.net>	<1253641129-28434-6-git-send-email-sage@newdream.net>	<1253641129-28434-7-git-send-email-sage@newdream.net>	<20090929171511.29836c82.akpm@linux-foundation.org>	<Pine.LNX.4.64.0912011648590.5806@cobra.newdream.net> <20091203123111.eef5a398.akpm@linux-foundation.org>
In-Reply-To: <20091203123111.eef5a398.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Thu, 3 Dec 2009 12:27:23 -0800 (PST)
> Sage Weil <sage@newdream.net> wrote:
> 
>> On Tue, 29 Sep 2009, Andrew Morton wrote:
>>> The code looks reasonable to me.  Unless others emit convincing
>>> squeaks, please ask Stephen to include your git tree into linux-next
>>> sometime within the next month, then send Linus a pull request for
>>> 2.6.33.
>> The code has seen 70 odd patches since then.  Mostly small fixes and 
>> cleanups, and a handful of larger changes.  Should these see the light of 
>> LKML before I send a pull request of Linus?  (So far they've just gone out 
>> to the ceph commit list.) I don't want to spam everyone with a huge series 
>> fixing up as yet unmerged code, but I'm not sure that review on the ceph 
>> lists is sufficient, given the frequency with which I see fs series on 
>> LKML...
>>
>> What are the best practices here?
>>
> 
> My preference would be to fold all the little fixes back into the main
> patch series then reissue it all as a nice patchset for people to
> re-review.
> 
> But that practice has largely gone by the wayside in recent years
> because of git-enforced restrictions :(.  It might muck up your
> development history to an unacceptable-to-you extent also, dunno.

also, many of us just don't have time to review (large) patches
like we did in the past.  The number of patch reviewers is way down
in my non-statistical estimate.  :(

~Randy
