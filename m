Return-Path: <linux-kernel-owner+w=401wt.eu-S1761631AbZLLKg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761631AbZLLKg0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Dec 2009 05:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbZLLKgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Dec 2009 05:36:24 -0500
Received: from mail-yw0-f182.google.com ([209.85.211.182]:55277 "EHLO
	mail-yw0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761475AbZLLKgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Dec 2009 05:36:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=htRvTnP2oN7NsrXlwVQ0zCNA7CBdXPsXvB+VYMGh/269x3/CShY3a51fHkMveEnbu8
         TsjkZ842ObbcApP7nt5bCtMr0Ijqd2TLZj6NjlNBGhNpgobXDoXHvwbrqNRWjlQE5MyC
         mtZgyWKwSNaptBqcIzeUI6Epw1ojCUVrfzA/w=
Message-ID: <4B23722A.5000507@gmail.com>
Date: Sat, 12 Dec 2009 05:36:26 -0500
From: William Allen Simpson <william.allen.simpson@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Jarek Poplawski <jarkao2@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Stephen Clark <sclark46@earthlink.net>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH v2] Documentation: rw_lock lessons learned
References: <4AF9C540.5090403@gmail.com>	<20091110180646.2e5859a8@nehalam>	<4AFAEF78.4080807@gmail.com> <20091111093724.4f40a48d@nehalam> <4AFBEC44.9030409@gmail.com> <4B227ADC.5010908@gmail.com> <4B22B481.9060600@gmail.com>
In-Reply-To: <4B22B481.9060600@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jarek Poplawski wrote:
> William Allen Simpson wrote, On 12/11/2009 06:01 PM:
>> A month ago, I'd taken the final line "Ho humm.." of Linus'
>> response to mean he wasn't interested.  But at the local
>> discussion yesterday, I'm told that's just a typical Linusism.
> 
> Why would he write 6 paragraphs if he wasn't interested?
> 
Good point.  Since I've only met him a couple of times, roughly a
decade or so ago, it wasn't obvious to me that it wasn't just a rant.


>> The thread diverged into discussion of another document entirely.
>>
>> I'm not the person to update this document with any of the other
>> information about global locks and tasklists and such.  But surely
>> somebody else could handle that in another patch.
>>
>> Anybody have answers/updates to Linus's concerns about "pretty old
>> and bogus language"?  Would folks be interested in the update?
>> Does anybody know which list(s) would be better for discussion?
> 
> I guess, you could literally start with removing this "global
> interrupt lock", adding "the example of a _good_ case of rwlocks",
> plus Stephen's "it is not just networking" fix in v3.
> 
As I mentioned, I'm not the person to do either of the former -- I'm
simply not conversant with the details.  If anybody has more specific
information, I'd be happy to edit it together with mine.  Or it could
be another patch entirely.

I'll do the latter later today.  Thanks for your interest.
