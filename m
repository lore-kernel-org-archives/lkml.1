Return-Path: <linux-kernel-owner+w=401wt.eu-S1757317AbZCCW5a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757317AbZCCW5a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:57:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755039AbZCCW5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:57:19 -0500
Received: from mail.lang.hm ([64.81.33.126]:48159 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbZCCW5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:57:18 -0500
Date: Tue, 3 Mar 2009 14:55:34 -0800 (PST)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Greg KH <greg@kroah.com>,
       Jeff Garzik <jeff@garzik.org>,
       wireless <linux-wireless@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Theodore Tso <tytso@mit.edu>
Subject: Re: Elaboration on "Equivalent fix must already exist in Linus'
 tree"
In-Reply-To: <43e72e890903031043m1fe417eay4420e734064a5882@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0903031454010.30837@asgard.lang.hm>
References: <43e72e890903022143k83890afr6673753f52c5ff8@mail.gmail.com>  <49ACC6B0.409@garzik.org>  <43e72e890903022244j2b2f4276lf6e318f3dad3df@mail.gmail.com>  <20090303072637.GB4440@kroah.com>  <43e72e890903022337k5281a790j8641f93cce3f9c70@mail.gmail.com>
  <49AD4C74.1060704@s5r6.in-berlin.de>  <43e72e890903030923v27c47f5anc184c0e8085bc5c1@mail.gmail.com>  <49AD7361.308@s5r6.in-berlin.de> <43e72e890903031043m1fe417eay4420e734064a5882@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="680960-2025645448-1236120935=:30837"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--680960-2025645448-1236120935=:30837
Content-Type: TEXT/PLAIN; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT

On Tue, 3 Mar 2009, Luis R. Rodriguez wrote:

> On Tue, Mar 3, 2009 at 10:13 AM, Stefan Richter
> <stefanr@s5r6.in-berlin.de> wrote:
>> Luis R. Rodriguez wrote:
>>> On Tue, Mar 3, 2009 at 7:27 AM, Stefan Richter
>>> <stefanr@s5r6.in-berlin.de> wrote:
>>>> Luis R. Rodriguez wrote:
>>>>> OK small silly example is convincing distributions it may be a good
>>>>> idea to carry linux-next kernel packages as options to users to
>>>>> hopefully down the road reduce the delta between what they carry and
>>>>> what is actually upstream.
>>>> Distros would do their users a bigger favour if [...]
>>>
>>> I don't think I was very clear in what I meant about "carrying
>>> linux-next kernel packages as an option". What I meant was carrying it
>>> just as an option for those users who want to test bleeding edge
>>> without compiling their own linux-next, _not_ to merge linux-next
>>> things into their own default kernel release and shove it down users
>>> throats.
>>
>> Sorry, I meant "bigger favour" relative to carrying an own delta of
>> considerable size.
>>
>> Packaging linux-next would be fine if the workload isn't a problem for
>> the packager.  As pointed out elsewhere, there are caveats with
>> linux-next (e.g. a functionality which was in it yesterday could be gone
>> today because of a merge issue), but that's the nature of bleeding edge
>> of course.
>
> Sure, understood. That's all I meant really.
>
> My argument here I guess is that the reasons used to support the
> "equivalent fix" policy for patches upstream makes it apparent why
> linux-next is so important and my hope would be to get it more
> exposure by having distributions let users test it (as an option to go
> with bleeding edge) and this in turn help stabilize code in our next
> release.

what does "equivalent fix" in the linus tree have to do with -next?

patches don't go always go through -next to get to linus, things that are 
in -next don't nessasarily _ever_ get to linus.

you are mixing issues here.

David Lang

--680960-2025645448-1236120935=:30837--
