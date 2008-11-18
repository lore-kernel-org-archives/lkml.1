Return-Path: <linux-kernel-owner+w=401wt.eu-S1754132AbYKRQwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132AbYKRQwd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752047AbYKRQwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:52:25 -0500
Received: from an-out-0708.google.com ([209.85.132.243]:9652 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbYKRQwZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:52:25 -0500
Message-ID: <7a9e70560811180852y9eb2bf6s8682609dcb10fd9f@mail.gmail.com>
Date: Tue, 18 Nov 2008 17:52:21 +0100
From: "=?ISO-8859-1?Q?Fredrik_Markstr=F6m?=" 
	<fredrik.markstrom@avalonenterprise.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Subject: Re: Developing non-commercial drivers ?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4922ED5A.3030808@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <fc262dee0811180816k29cc93aas51c2c47ede2c7a1@mail.gmail.com>
	 <4922ED5A.3030808@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the prompt respons.

I do agree that it would be better for everyone to release it under
GPL and I have already expressed that to our customer.

At this point I feel that we have two possibilities, help our customer
violate GPL or say no to the project. I'd prefer a third option where
I could tell the customer that we can setup the project in a certain
way (some "cleanroom" setup ?) to ensure that the results can not be
considered derived work.

Is your short answer also the definite answer considering this ?

/Fredrik




2008/11/18 Robert Hancock <hancockr@shaw.ca>:
> Fredrik Markström wrote:
>>
>> Linus, others...
>>
>> I'm working for as a consultant for a large hardware company porting
>> Linux to their new cpu-architecture and everything is pretty much
>> up and running. Now they want us to develop a closed-source (to
>> protect their IP) ethernet driver for their proprietary Ethernet MAC.
>>
>> My question is:    Is there a fair way to do this and still comply to
>> the intent and spirit of the Linux licensing ?
>>
>> If yes, how ?
>
> In a word, I would say: no.
>
> When developing a non-GPL kernel driver, one finds themselves on very shaky
> legal ground. Unless one is 100% sure their code is not legally considered a
> derived work from the kernel, it's likely a GPL violation.
>
> One could point out the pile of other Ethernet drivers in the kernel from
> the likes of Intel, Broadcom, etc. and ask why those companies did not feel
> the need to "protect their IP" in this manner.. as well as the significant
> advantages of having their driver in the mainline kernel, and the horrible
> disadvantages of trying to manage closed-source drivers..
>
