Return-Path: <linux-kernel-owner+w=401wt.eu-S1754136AbZF3Brj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbZF3Brj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752674AbZF3Brc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:47:32 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:39258 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486AbZF3Brb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:47:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=IGxdDQPb+oSuVSHk1e3R3lzDEA85wBs/hB1qFQS/nAHjmFzz7zmO5a3MSx3IZ74BHH
         ry7zOoSmQtiRbJhZKqShk12LkqSiePCyk62NOTGVD8BzbFc/qcv9cx8P0z3BMjEyeyPo
         X28vFdVJIiLoGS9Ek+bzBXyw2Z7LMsKtCgdPI=
MIME-Version: 1.0
In-Reply-To: <20090630011709.GT20436@tamriel.snowman.net>
References: <20090628034038.GK20436@tamriel.snowman.net>
	 <20090628172052.GA13957@ldl.fc.hp.com>
	 <20090628223258.GP20436@tamriel.snowman.net>
	 <20090630011541.GL22480@ldl.fc.hp.com>
	 <20090630011709.GT20436@tamriel.snowman.net>
Date: Mon, 29 Jun 2009 18:47:34 -0700
Message-ID: <86802c440906291847p302d47eau1d1cbd07be59c61@mail.gmail.com>
Subject: Re: ACPI issues on HP DL585 G2
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Stephen Frost <sfrost@snowman.net>
Cc: dann frazier <dannf@hp.com>, Alex Chiang <achiang@hp.com>,
       linux-kernel@vger.kernel.org, David Altobelli <david.altobelli@hp.com>,
       nagananda.chumbalkar@hp.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 6:17 PM, Stephen Frost<sfrost@snowman.net> wrote:
> * dann frazier (dannf@hp.com) wrote:
>> On Sun, Jun 28, 2009 at 06:32:58PM -0400, Stephen Frost wrote:
>> > * Alex Chiang (achiang@hp.com) wrote:
>> > > I'm just scanning mail on the weekend, but what version of the
>> > > BIOS are you on? Do you have the latest?
>> >
>> > Check the message I just posted, it includes a dmesg under 2.6.30 (also
>> > with noapic, since it didn't boot w/o it again).
>>
>> fyi, I tested an HP DL585 G2 w/ the same 2.6.30 kernel build
>> and didn't have any problems. I am running the A07 3/11/2009 BIOS.
>> dmesg output follows:
>
> Yeah, it's working fine on some of my other DL585's too. :/  I've really
> got no idea what's up with this box.  Thanks for the info tho.

it seems storage cards are different.

dann's is 42:01.0 the LSI
your's is 42.02.0 the cciss?

YH
