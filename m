Return-Path: <linux-kernel-owner+w=401wt.eu-S1757488AbXHPMJk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbXHPMJk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 08:09:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbXHPMJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 08:09:33 -0400
Received: from odyssey.analogic.com ([204.178.40.5]:2616 "EHLO
	odyssey.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbXHPMJb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 08:09:31 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 16 Aug 2007 12:09:25.0876 (UTC) FILETIME=[49F3F340:01C7DFFE]
Content-class: urn:content-classes:message
Subject: Re: Thinking outside the box on file systems
Date: Thu, 16 Aug 2007 08:09:25 -0400
Message-ID: <Pine.LNX.4.61.0708160754220.17345@chaos.analogic.com>
In-Reply-To: <46C43818.4050506@aitel.hist.no>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Thinking outside the box on file systems
Thread-Index: Acff/kn9rLxTyMXlSsOaQTAESX2WBg==
References: <174219.56922.qm@web52501.mail.re2.yahoo.com> <46C43818.4050506@aitel.hist.no>
From: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
To: "Helge Hafting" <helge.hafting@aitel.hist.no>
Cc: "Marc Perkel" <mperkel@yahoo.com>, "Kyle Moffett" <mrmacman_g4@mac.com>,
       "Michael Tharp" <gxti@partiallystapled.com>,
       "alan" <alan@clueserver.org>,
       "LKML Kernel" <linux-kernel@vger.kernel.org>,
       "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Reply-To: "linux-os \(Dick Johnson\)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 16 Aug 2007, Helge Hafting wrote:

> Marc Perkel wrote:
>> Kyle, What I'm suggesting is scrapping all existing
>> concepts and replacing them with something entirely
>> new. Posix, Unix, SELinux go away except for an
>> emulation layer for backwards compatibility. What I'm
>> suggesting is to start over and do it right.
>>
> If you want to get any support for "starting over",
> then  you need to:
> 1. Point out some serious problem with the existing stuff,
>   otherwise why _bother_ start over
> 2. Come up with a truly better idea (demonstrably better)
>    that isn't full of so obvious flaws that a seasoned kernel
>    developer can shoot it down in 5 minutes.
>
> Trying to be a visionary with a "great idea" that you are
> prepared to let others implement just don't work on
> this list.  If you want to go that route, you
> start a company, hire programmers, tell them to
> implement your vision. If your idea is good then
> your company succeeds.
>
> If you want to be an open-source visionary, you have to
> do the initial work yourself until you attract other interested people.
>
>> One of the problems with the Unix/Linux world is that
>> your minds are locked into this one model. In order to
>> do it right it requires the mental discipline to break
>> out of that.
>>
> Or perhaps unix have the best model already? ;-)
> If you want a big break with the existing unix models, then
> perhaps a entirely new project is in order, rather than
> trying to change linux. Linux is after all, in use by millions
> who are satisfied with the linux filesystem model already.
>
> Now, linux is open-source, so you can of course use it as a
> starting point for your different system.  Then you can compete
> with "standard linux" - see who attracts most developers and
> most users in the long run.
>
> Helge Hafting
> -

I think Marc Perkel's basic idea was implimented under CP/M as
a "user level." Also, the concept of a virtual directory structure
has been around about as long as "container files," such as those
on the old Intel MDS200 development station. This is hardly
"thinking out-of-the-box." It's just a rehash of some abandoned
stuff.

That said, a major speed limitation of directory lookups
is the manipulation and comparison of variable-length strings.
Maybe Mark might be able to improve this by truly thinking
out-of-the-box.

Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.29 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.

Thank you.
