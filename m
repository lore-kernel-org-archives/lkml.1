Return-Path: <linux-kernel-owner+w=401wt.eu-S1761005AbYG1SLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761005AbYG1SLf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760801AbYG1SLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:11:06 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:33648 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758750AbYG1SLF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:11:05 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=HCqiOiagBIwsxIs9w0xv6bCvaGQolBe+O7HEcM0Yse1TmxNwdN3bxRM8HYesf4pvYSuoy+697oLY/mUiC7juFwZp7x5fZ0KYo1dwsYg4OseNLrE2O7VGKwmF6S99vWb0;
Message-ID: <488E0BB6.7020006@simon.arlott.org.uk>
Date: Mon, 28 Jul 2008 19:11:02 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>	 <488DF9CF.8020408@simon.arlott.org.uk>	 <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>	 <488DFD97.7080802@simon.arlott.org.uk> <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
In-Reply-To: <9e4733910807281022v38d323c9sc7b63235824690f6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/08 18:22, Jon Smirl wrote:
> On 7/28/08, Simon Arlott <simon@fire.lp0.eu> wrote:
>> On 28/07/08 18:05, Jon Smirl wrote:
>> > On 7/28/08, Simon Arlott <simon@fire.lp0.eu> wrote:
>> > >  Just because anyone can grep the kernel log for email addresses [to
>> send
>> > > spam to], doesn't mean that you need to do it for them.
>> > >
>> >
>> > You need to be in the file since you have submitted patches using three
>> aliases.
>> >
>>
>>  No, I've submitted patches using three email addresses (well, two - one is
>> a typo).
> 
> That's the whole point of this list. When you submit patches in the
> future we can check your name/email against the list and flag it if it
> isn't there. That will alert you that you've made a typo.

I don't make typos in my name or email address.

> A later version of this list could separate the valid current
> names/addresses from the entries that are fixing typos or that have
> old emails. That would improve the validation. But I don't have an
> automated way to tell me which alias is the current one. Access to the
> current LKML subscriber list would supply the needed info as to which
> one to pick.

Validation of what?
The current alias is the most recent active one.

I'm not subscribed to the LKML with a public address.
Please Cc: me if you submit a patch for this so I can add a Nacked-By: 
and/or cleanup the list by removing redundant entires. Even if git-shortlog 
is changed to distinguish between people who share the same name, it would 
still be a list of exceptions rather than everyone.

-- 
Simon Arlott
