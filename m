Return-Path: <linux-kernel-owner+w=401wt.eu-S934798AbXGQQYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934798AbXGQQYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 12:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762155AbXGQQYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 12:24:22 -0400
Received: from dns.hk.18mail.cn ([210.245.210.181]:38976 "EHLO
	hkm1.server.hk.18mail.cn" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbXGQQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 12:24:21 -0400
Message-ID: <469CED27.4060904@zh-kernel.org>
Date: Wed, 18 Jul 2007 00:24:07 +0800
From: Li Yang <leo@zh-kernel.org>
Reply-To: leo@zh-kernel.org
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Tsugikazu Shibata <tshibata@ab.jp.nec.com>, rob@landley.net
Cc: gh@us.ibm.com, hpa@zytor.com, kunai@linux-foundation.jp,
       holzheu@linux.vnet.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org
Subject: Re: [PATCH] Chinese Language Maintainer
References: <1184330583.23373.65.camel@Gundam>	<200707131352.12952.rob@landley.net>	<a0bc9bf80707150742kf217ff3g8dc65efccfa692cc@mail.gmail.com> <20070716.114948.48508930.tshibata@ab.jp.nec.com>
In-Reply-To: <20070716.114948.48508930.tshibata@ab.jp.nec.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tsugikazu Shibata wrote:
> On Sun, 15 Jul 2007 22:42:07 +0800, leo wrote:
>> On 7/14/07, Rob Landley <rob@landley.net> wrote:
>>> On Friday 13 July 2007 8:43:03 am Li Yang wrote:
>>>> On Thu, 2007-07-12 at 12:05 -0400, Rob Landley wrote:
>>>>> +A language maintainer accepts patches to the Linux kernel, written in C,
>>>>> from +authors who do not also speak English.  The language maintainer
>>>>> translates the +description of each patch into English, forwards the
>>>>> patches to linux-kernel +and to the appropriate maintainers for inclusion
>>>>> in the Linux kernel, and +translates questions and replies about such
>>>>> patches as part of the +patch review process.
>>>> In addiction to this responsibility, I would like to add two more which,
>>>> in my opinion, are more important.  And these are what I'm trying to
>>>> do.  :)
>>>> First, promoting contribution to Linux kernel in local language.
>>>> Second, coordinate the translation effort of key kernel documents.
>>> Cool.  It's good to do that, but not the problem I'm worried about solving.
>>>
>>> I was trying to describe the minimum requirements for being a language
>>> maintainer, I.E. what non-english users need in order to be able to merge
>>> their patches.  Because without someone to contribute patches to (I.E a
>>> language maintainer), documentation in non-english languages promotes the
>>> creation of patches that can't be merged.  That's the problem I'm trying to
>>> solve.
>>>
>>> To me, finding language maintainers is the flip side of the coin of
>>> translating documentation.
>> I think you worried too much about this problem.  :)  Let me explain
>> the situation here in China more clearly.  Actually, English is
>> mandatory in most schools and universities.  Only very few people
>> learn other language as a second language.  Therefore software
>> developers who are almost educated should have the basic English
>> skill.  However, that doesn't mean that they can read English or
>> communicate with native English speaker very easily.  Consider your
>> second language learn in school for analogy.  Read in English will be
>> much slower and more likely to cause misunderstanding.  This will
>> reduce the likelihood greatly of English documentation being read.  If
>> we are promoting contribution to the Linux community, we should
>> maximum the possibility that these key documents being read.
>> Translation will serve this purpose very well.
>>
>> So the possibility is very little that a translator is needed between
>> the Linux maintainer and a Chinese developer.  Although sometimes help
>> is needed when there is misunderstanding.
>>
>> After a brief talk with the Japanese translator, I think the case is
>> similar for Japanese too.
> 
> Yes, In Japan, situation is mostly the same.
> We are trying to increase number of Linux community developer with
> Linux Foundation Japan or CELF people in Japan.
> In our discussion, the problem is not only Language.
> 
> In case of some developer, once he step forward (he try to send patch
> or comment on LKML), he got some comment and he can work with
> community even if it's slow (because of he was non-native).
> So, I thought if some key document are available in Japanese like
> HOWTO, that will help such early stage of developers.
> 
>> Therefore, in my opinion, language maintainer should be more a helper
>> and promoter rather than a gatekeeper.  I will give a proposed process
>> later about how this helper mechanism works.
> 
> I will be able to help this as a stand point of Japanese situation.

Here is the helper process I propose to help more people to participate. 
  Suggestions and comments are welcomed.

1) Developer who can't speak English or has a problem going through the 
submission process sends patches to the Language maintainer and cc the 
local mail list provided.
2) Language maintainer and experienced Linux developer on the local mail 
list can review the patch and give comments in native language.
3) When the language maintainer thinks the patch is good in general, he 
will pass the patch onto corresponding subsystem maintainer and mail 
list for further review, cc the author and local list.
4) The author communicates directly with the community.
5) If the author has a problem understanding the comments or expressing 
himself in English, he can ask for help in native language on the local 
list.  The language maintainer and the developers on the list are 
responsible to help out.
6) When the developer gets familiar with the submission process and can 
go through it with no problem, he can then submit patch directly without 
the helper process and probably join the mail list to help other new 
developer.

- Leo
