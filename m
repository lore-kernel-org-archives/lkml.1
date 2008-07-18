Return-Path: <linux-kernel-owner+w=401wt.eu-S1754374AbYGRJDK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbYGRJDK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:03:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753799AbYGRJC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:02:56 -0400
Received: from smtp-out01.alice-dsl.net ([88.44.60.11]:31388 "EHLO
	smtp-out01.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbYGRJCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:02:55 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Parag Warudkar <parag.warudkar@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: From 2.4 to 2.6 to 2.7?
From: Andi Kleen <andi@firstfloor.org>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com>
	<alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org>
	<87skubxxtq.fsf@basil.nowhere.org>
	<loom.20080715T151953-255@post.gmane.org>
	<20080715163205.5eddba46@the-village.bc.nu>
Date: Fri, 18 Jul 2008 11:02:22 +0200
In-Reply-To: <20080715163205.5eddba46@the-village.bc.nu> (Alan Cox's message of "Tue, 15 Jul 2008 16:32:05 +0100")
Message-ID: <87iqv3sgyp.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 18 Jul 2008 09:02:20.0513 (UTC) FILETIME=[FC533D10:01C8E8B4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> On Tue, 15 Jul 2008 15:27:56 +0000 (UTC)
> Parag Warudkar <parag.warudkar@gmail.com> wrote:
>
>> Andi Kleen <andi <at> firstfloor.org> writes:
>> 
>> 
>> > Or you could just do it like emacs or Solaris and simply use a single number.
>> 
>> No - because then those handful of Solaris supporters will get one more 'proof'
>> in support of their claims of Linux copying Solaris - first SystemTap copying
>> DTrace and now version numbers. See how we stand a risk of ending up convinced
>> we do not innovate?
>
> "Support" - dtrace is based on the IBM work it seems, and the IBM work
> predates Solaris dtrace by a long time, so actually you could argue
> Solaris copied Linux but shipped first ;)

Actually SLES9 shipped with IBM dprobes[1] long before Solaris dtrace even
existed (and OS/2 did long before that). Back then the interest in it
was about zero though, which made SLES10 drop it again. 
I think I was one of the very few users.  Admittedly the early RPN
probes were also not particularly user friendly, but they worked.

I use this always as an example that even sophisticated users 
like system administrators and kernel hackers are somewhat marketing driven.

-Andi

[1] which BTW already supported user space probes
