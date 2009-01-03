Return-Path: <linux-kernel-owner+w=401wt.eu-S932114AbZACDtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbZACDtw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 22:49:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758873AbZACDtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 22:49:43 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:64762 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869AbZACDtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 22:49:42 -0500
Message-ID: <f488382f0901021949y60b6d60fjeaeb6bb12a851f8@mail.gmail.com>
Date: Fri, 2 Jan 2009 19:49:39 -0800
From: "Steven Noonan" <steven@uplinklabs.net>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: ath9k microwave anomaly
Cc: "Dave Jones" <davej@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <495EDC10.20605@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <495ED1C4.8020304@gmail.com> <20090103032134.GA20209@redhat.com>
	 <495EDC10.20605@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 2, 2009 at 7:31 PM, Justin P. Mattock
<justinmattock@gmail.com> wrote:
> Dave Jones wrote:
>>
>> On Fri, Jan 02, 2009 at 06:47:32PM -0800, Justin P. Mattock wrote:
>>  > Now I'm not trying to be funny,
>>  > but I think I figured a problem
>>  > with running ath9k, and having the internet
>>  > timeout.(for me at least);
>>  > When streaming T.V.(cspan2), and
>>  > streaming music(somafm), at the same time,
>>  > then using the microwave, I'll experience a blackout
>>  > of internet(T.V. stops, then music stops streaming);
>>
>> not specific to ath9k.
>>
>> http://blogs.zdnet.com/Ou/?p=578 has some pretty graphics
>> to show just how much noise a microwave puts into the part
>> of the spectrum wifi uses.
>>
>>        Dave
>>
>>
>
> Damn that's allot,
> no wonder I was having these timeouts.
> i.g. system streams fine for 10 hours.
> then the next day a timeout after 2 hours due
> to microwave use.
> Thanks for pointing that blog out.
> that opened my eyes up to how powerful
> a microwave is. makes me wonder if that
> grade in the window actually does what is supposed to.
> (block gamma rays or whatever the dangerous wave is);
>
> regards;
>
> Justin P. Mattock
>
Yeah, I think it was Luis Rodriguez (from Atheros) who told me that a
microwave was the best way to make a signal "wet poop" for
interference testing.
