Return-Path: <linux-kernel-owner+w=401wt.eu-S932068AbZGNGrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbZGNGrb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 02:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZGNGra
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 02:47:30 -0400
Received: from mail-qy0-f192.google.com ([209.85.221.192]:64179 "EHLO
	mail-qy0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbZGNGra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 02:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iCzkSvu8fzVlk6o5Ggx4oyWyezz3SHW7Zjz978w/hta+2nCIkAnz9UISLq5KoWlm66
         sQ25075TUG+P+Mzq32h5As0w50hlf13sofK/egsvB/AKCnZNvrlXbWt80qDoeaezqAcw
         1wM0xD6WYkRP9nsq6yByKhvQi78hFfX8bZ770=
MIME-Version: 1.0
In-Reply-To: <1247536087.31854.39.camel@desktop>
References: <20090710084323.GA6522@elf.ucw.cz>
	 <a55d774e0907100155m25366994pe9ec5d0f5f868818@mail.gmail.com>
	 <20090710103243.GB7789@elf.ucw.cz>
	 <a55d774e0907100431j3fdc4671i6b185019594367fa@mail.gmail.com>
	 <20090713202302.GC2569@elf.ucw.cz> <20090713205749.GE2569@elf.ucw.cz>
	 <20090713220726.GA28375@elf.ucw.cz>
	 <1247536087.31854.39.camel@desktop>
Date: Tue, 14 Jul 2009 12:17:29 +0530
Message-ID: <5d5443650907132347r82e73cy7177f0c43d1821c0@mail.gmail.com>
Subject: Re: HTC: touchscreen driver
From: Trilok Soni <soni.trilok@gmail.com>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Pavel Machek <pavel@ucw.cz>, Brian Swetland <swetland@google.com>,
       kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

On Tue, Jul 14, 2009 at 7:18 AM, Daniel Walker<dwalker@fifo99.com> wrote:
> On Tue, 2009-07-14 at 00:07 +0200, Pavel Machek wrote:
>> On Mon 2009-07-13 22:57:49, Pavel Machek wrote:
>> > Hi!
>> >
>> > I'm looking at synaptic touchscreen driver... who should be listed as
>> > an author?
>> >
>> > Changes I have so far are...
>> >
>> > checkpatch only has minor complains -- lines over 80 characters -- but
>> > the code is _way_ too deeply nested with way too little functions.
>>
>> Here's better cleanup. But... some functions are still _way_ too big.
>>
>
> I'd put the nesting removal into another patch .. It makes reviewing
> more clear, your first patch was already fairly busy .. It would also
> make a bisect more fine grained if it lands on one of your patches.

Please keep linux-input ML for any updates or when you have single
patch ready to submit for review.


-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
