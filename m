Return-Path: <linux-kernel-owner+w=401wt.eu-S1756788AbYG3VFc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788AbYG3VFc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 17:05:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYG3VFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 17:05:24 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:36161 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbYG3VFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 17:05:23 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=MmMVES8F5i5D35vCfcHff5hK8rxRumhiM3ZmNfa/FYjQFRb7v1r24xeHNhCsVi9M86NjlItSxhgEP98hWe7NZlaQOfYMIUMVoSoZ2aFEPElVJgs5geWWFcYzPbmEni5Z;
Message-ID: <4890D77F.7020603@simon.arlott.org.uk>
Date: Wed, 30 Jul 2008 22:05:03 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Alan Cox <alan@letsannoyjonsmirl.ukuu.org.uk>,
       Theodore Tso <tytso@mit.edu>, davids@webmaster.com,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <4890284E.3050806@s5r6.in-berlin.de>	 <MDEHLPKNGKAHNMBLJOLKAEDIOJAC.davids@webmaster.com>	 <20080730155359.7c0206f4@lxorguk.ukuu.org.uk>	 <9e4733910807300823x516eb45dx877898f9d7c8be57@mail.gmail.com>	 <20080730161408.4dfa6fe8@lxorguk.ukuu.org.uk>	 <20080730164056.GB8283@mit.edu>	 <20080730174957.3d1d63ee@lxorguk.ukuu.org.uk> <9e4733910807301158w7512fd1l78cc8f092383f871@mail.gmail.com>
In-Reply-To: <9e4733910807301158w7512fd1l78cc8f092383f871@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/07/08 19:58, Jon Smirl wrote:
> On 7/30/08, Alan Cox <alan@letsannoyjonsmirl.ukuu.org.uk> wrote:
>> > debate it in a bar at some future conference.  But does it really make
>>  > sense to argue about it here?
>>
>>
>> No but perhaps Jon could simply show some manners when people request him
>>  politely not to do that. He doesn't seem to want to debate manners, just
>>  law.
> 
> I didn't handle the removing the people from the list issue very well.
> I got caught in the fact the log immutably records history and I
> objected to editing history. I viewed this along the lines of George
> Washington asking to be removed from text books. He was the first
> president; we can't change that and we have to include him in the list
> of presidents.
> 
> I still don't have a good solution for how to track the people who
> don't want their names to appear without creating yet another list.
> 

It's really simple - if there is actually some benefit to them being 
in .mailmap (because their name is spelled differently in some commits), 
then contact them. Otherwise, you can assume they don't want to be on it.

That should cut down the number of people considerably... I can only see 
one example in the A section (Auke Kok).

-- 
Simon Arlott
