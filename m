Return-Path: <linux-kernel-owner+w=401wt.eu-S1760282AbYG1RK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282AbYG1RK6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757298AbYG1RKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:10:51 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:50415 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbYG1RKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:10:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	b=SQqpGi4aSZ7LNbRim0JmeYjOuNrrA60rAXDDa2Rmfvp9dl3h3U37F1pks3hjXUKNpdCg1+6NgrFlRUqsluL/k+WBtrnhNo+4HTx5n2VJu9THkWnz2GclA4z0O12Pl3C8;
Message-ID: <488DFD97.7080802@simon.arlott.org.uk>
Date: Mon, 28 Jul 2008 18:10:47 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: 463 kernel developers missing!
References: <9e4733910807280745l248801ebp134e77fc1ac70c02@mail.gmail.com>	 <488DF9CF.8020408@simon.arlott.org.uk> <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
In-Reply-To: <9e4733910807281005y62dca90ar96f663908e644546@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/07/08 18:05, Jon Smirl wrote:
> On 7/28/08, Simon Arlott <simon@fire.lp0.eu> wrote:
>> On 28/07/08 15:45, Jon Smirl wrote:
>>
>> > Here's a new .mailmap file for the kernel that cleans up the horrible
>> > mess of names and email addresses in the log.  To use it put it at the
>> > root of your kernel tree and type 'git shortlog'. Before the clean up
>> > there were 4,284 developers, after 3,821. There are 5,051 unique
>> > emails.
>> >
>> > The mailmap file contains all email addresses that have been used to
>> > submit patches to the kernel. Don't freak out about your email address
>> > being in the file, if it is in the file it is already in Google since
>> > the kernel log is already in Google.
>> >
>>
>>  Just because anyone can grep the kernel log for email addresses [to send
>> spam to], doesn't mean that you need to do it for them.
> 
> You need to be in the file since you have submitted patches using three aliases.

No, I've submitted patches using three email addresses (well, two - one is 
a typo).
 
>>  Please read git-shortlog(1) and then remove me from this file because it
>> won't change anything.

Try running "git shortlog" too, you'll see I only appear once using the 
existing 99-line .mailmap file.

-- 
Simon Arlott
