Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbXJWVy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbXJWVy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 17:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbXJWVyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 17:54:19 -0400
Received: from mail.tmr.com ([64.65.253.246]:55260 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752669AbXJWVyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 17:54:18 -0400
Message-ID: <471E6FC2.1070401@tmr.com>
Date: Tue, 23 Oct 2007 18:03:46 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Federico Sevilla III <jijo@fs3.ph>, linux-kernel@vger.kernel.org
Subject: Re: "spurious completions during NCQ" with 2.6.23.1 and DVD   Multi-Recorder
 on Thinkpad T61
References: <1193018170.4672.20.camel@humanitas.fs3.ph> <20071022104619.0a554cea@the-village.bc.nu>
In-Reply-To: <20071022104619.0a554cea@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> On Mon, 22 Oct 2007 09:56:10 +0800
> Federico Sevilla III <jijo@fs3.ph> wrote:
> 
>> Hi,
>>
>> Using the 2.6.23.1 kernel and Debian Etch on a Lenovo Thinkpad T61
>> 7659A21, I am getting two weird errors, as follows:
> 
> Turn off bluetooth and you may find the stuck IRQ goes away - at least on
> some thinkpads there are weird extra IRQs when bluetooth is running which
> break stuff.
> 
There was an old American Music/Comedy show called "Hee Haw!" which had 
a recurring skit consisting of a farmer running into the doctor's office 
and saying
   "Doctor, doctor! It hurts when I do this!" followed by some unlikely 
activity.
   The doctor always replied "Then don't do that."

Turning off bluetooth is a useful diagnostic test, but for some systems 
it's not a practical operating configuration. Any thoughts on making 
bluetooth work in these cases? Most laptops make a unit like the 
Logitech MX5000 BT keyboard desirable for extended use.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
