Return-Path: <linux-kernel-owner+w=401wt.eu-S1759701AbYBKROW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759701AbYBKROW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 12:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757410AbYBKROF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 12:14:05 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:33823 "EHLO
	bh-buildlin1.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYBKROC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 12:14:02 -0500
Message-ID: <47B0823D.1010008@panasas.com>
Date: Mon, 11 Feb 2008 19:13:33 +0200
From: Benny Halevy <bhalevy@panasas.com>
Organization: Panasas, Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
CC: Mark Hounschell <markh@compro.net>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi_error: Fix language abuse.
References: <20080208153217.5fc42a50@core> <1202486247.3102.17.camel@localhost.localdomain> <Pine.LNX.4.61.0802081104370.27386@chaos.analogic.com> <47AC82D7.2070502@compro.net> <Pine.LNX.4.61.0802111059270.8512@chaos.analogic.com>
In-Reply-To: <Pine.LNX.4.61.0802111059270.8512@chaos.analogic.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seriously, can't you just add a disclaimer to the README file?

In http://lkml.org/lkml/2008/2/9/29, Luben Tuikov made an interesting
point that in many cases "illegal" refers to a valid value that violates
the specification, so the term "invalid" may be technically incorrect.

Benny

On Feb. 11, 2008, 18:07 +0200, "linux-os (Dick Johnson)" <linux-os@analogic.com> wrote:
> On Fri, 8 Feb 2008, Mark Hounschell wrote:
> 
>> linux-os (Dick Johnson) wrote:
>>> The correct word should be "invalid," in spite of
>>> the fact that the SCSI committee used invalid syntax.
>>>
>>> Alan is right. There is nothing illegal in the kernel
>>> and if there is, it must be removed as soon as it
>>> is discovered!
>>>
>> il·le·gal  (-lgl)
>> adj.
>> 1. Prohibited by law.
>> *2. Prohibited by official rules: an illegal pass in football.
>> *3. Unacceptable to or not performable by a computer: an illegal operation.
>>
>> Mark
> 
> Many early computer programmers including myself, while writing
> error messages in early software, did not understand that computer
> programmers do not make law so we called bad operations "illegal."
> 
> Once you are called to testify in a court of law, about some
> message your code wrote to the screen just before a factory
> burned down, you start to be much more careful about the syntax.
> 
> I advise that, regardless of the rewrite of dictionaries and,
> in fact, the rewrite of history, whenever possible we use
> the correct message syntax. Dictionaries pick up "common usage"
> in spite of the fact that it is wrong. See "irregardless" and
> other abortions which now exist in the dictionary.
> 
> 
> Cheers,
> Dick Johnson
> Penguin : Linux version 2.6.22.1 on an i686 machine (5588.28 BogoMips).
> My book : http://www.AbominableFirebug.com/
> _
> 
> ****************************************************************
> The information transmitted in this message is confidential and may be privileged.  Any review, retransmission, dissemination, or other use of this information by persons or entities other than the intended recipient is prohibited.  If you are not the intended recipient, please notify Analogic Corporation immediately - by replying to this message or by sending an email to DeliveryErrors@analogic.com - and destroy all copies of this information, including any attachments, without reading or disclosing them.
> 
> Thank you.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

