Return-Path: <linux-kernel-owner+w=401wt.eu-S1760605AbYG1R1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760605AbYG1R1p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 13:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755246AbYG1R1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 13:27:37 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:47988 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYG1R1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 13:27:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=JCQESSmA4H/gd2ONwiJRLtV3VdD7sa+C7lxIBRoEAVFrggZ5U/HPNfAuSi8ZZC6Ide
         Mx6zvgGQ7k5Aopu9QKIPdbHT38G5nYnOoHfj0eA1fdSffQyDriWB/nnUrw3wH2VDM0sb
         RhsF3KeDA7rtFPjYA5efl6IKGbBWBJYi9moZo=
Message-ID: <dd18b0c30807281027l251d5ec0q6532107c78061090@mail.gmail.com>
Date: Mon, 28 Jul 2008 10:27:35 -0700
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Alistair John Strachan" <alistair@devzero.co.uk>
Subject: Re: NETDEV WATCHDOG: wifi0: transmit timed out
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200807281622.43288.alistair@devzero.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30807280010h34002232wb53b7a154d9853fc@mail.gmail.com>
	 <20080728061226.26ffae06@infradead.org>
	 <dd18b0c30807280653q6c11cd6aia20946f6fd9acf0c@mail.gmail.com>
	 <200807281622.43288.alistair@devzero.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 28, 2008 at 8:22 AM, Alistair John Strachan
<alistair@devzero.co.uk> wrote:
> On Monday 28 July 2008 14:53:41 Justin Mattock wrote:
>> On Mon, Jul 28, 2008 at 6:12 AM, Arjan van de Ven <arjan@infradead.org>
> wrote:
>> > On Mon, 28 Jul 2008 00:10:46 -0700
>> >
>> > "Justin Mattock" <justinmattock@gmail.com> wrote:
>> >> I should'nt be posting this, due to
>> >> having  tainted modules(madwifi), but
>> >
>> > and fglrx
>> >
>> >> I figured I might as well:(below)
>> >>
>> >> [ 5000.986044] NETDEV WATCHDOG: wifi0: transmit timed out
>> >
>> > and what's more... it's the the wifi that's b0rked.
>> >
>> > sounds like you want to switch to ath5k or ath9k.
>> >
>> >
>> > --
>> > If you want to reach me at my work email, use arjan@linux.intel.com
>> > For development, discussion and tips for power savings,
>> > visit http://www.lesswatts.org
>>
>> If there's support for the 5418 card that the macbook pro has.
>> interesting when lspci I'm not seeing the card number(below is lspci)
>> As for the fglrx "f*&k it" too much of a pain.:
>
> Yep check out the linux-wireless archives for more info, but ath9k is ready
> and working on your hardware. I've got a Macbook with the same chipset and
> it's totally fine (2.6.26+wireless-testing+ath9k).
>
> --
> Cheers,
> Alistair.
>

Alright!!
I'm glad to hear this.
"natural and fresh".

-- 
Justin P. Mattock
