Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbXHQGbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbXHQGbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 02:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757542AbXHQGbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 02:31:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34081 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347AbXHQGbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 02:31:03 -0400
X-Greylist: delayed 31527 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2007 02:31:03 EDT
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46C53F50.9040107@s5r6.in-berlin.de>
Date: Fri, 17 Aug 2007 08:25:20 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.6) Gecko/20070807 SeaMonkey/1.1.4
MIME-Version: 1.0
To: Rene Herman <rene.herman@gmail.com>
CC: Alan Stern <stern@rowland.harvard.edu>, Kyle Moffett <mrmacman_g4@mac.com>,
       Salikh Zakirov <salikh@gmail.com>, Junio C Hamano <gitster@pobox.com>,
       LKML Kernel <linux-kernel@vger.kernel.org>,
       Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org, git@vger.kernel.org
Subject: Re: [linux-pm] Re: Storing Maintainers info around the kernel tree
References: <Pine.LNX.4.44L0.0708162156550.9927-100000@netrider.rowland.org> <46C5057C.5010602@gmail.com>
In-Reply-To: <46C5057C.5010602@gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rene Herman wrote:
> On 08/17/2007 03:58 AM, Alan Stern wrote:
> 
>> On Fri, 17 Aug 2007, Rene Herman wrote:
>>
>>> On 08/16/2007 11:39 PM, Stefan Richter wrote:
>>>> Rene Herman wrote:
> 
>>>>> I personally don't think there's a whole lot wrong with more and
>>>>> more expecting people who submit patches (for whom this automation
>>>>> is intended) to be using git.
>>>>
>>>> You mean "people who frequently submit patches for various different
>>>> subsystems".
>>>
>>> Erm, I guess. Is that agreeing or disagreeing with me?
>>
>> Don't forget also that the MAINTAINERS information is (or should be!)
>> used by people who want to submit bug reports, not just by people who
>> submit patches.  Bug reporters shouldn't need to use Git.

Yes, problem reporters and people who infrequently (or for their first
time) submit patches, and even people who frequently submit patches but
most of the time only to the same one or two subsystems need an obvious,
tool-independent way to get contact information.

> Like I said:
> 
>>> If it's about non-developer users, I suspect it would to a fairly large
>>> degree be an "in theory" thing to expect that said user does want the
>>> information in a downloaded releases, but not in git, and not online
>>> where git-web could also easily display all the information right
>>> alongside the files.
> 
> And again, generating the MAINTAINERS file/info into releases is fine as
> well.

Good.  This generated data will be used by almost everyone except for a
certain special group of submitters.
-- 
Stefan Richter
-=====-=-=== =--- =---=
http://arcgraph.de/sr/
