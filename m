Return-Path: <linux-kernel-owner+w=401wt.eu-S1751917AbXJVW3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbXJVW3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 18:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbXJVW3l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 18:29:41 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:57747 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbXJVW3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 18:29:41 -0400
Message-ID: <471D23AA.2000803@keyaccess.nl>
Date: Tue, 23 Oct 2007 00:26:50 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Roel Kluin <12o3l@tiscali.nl>
CC: Ray Lee <ray-lk@madrabbit.org>, Rik van Riel <riel@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] return hidden bug
References: <471BF741.2020501@tiscali.nl>	 <20071021214209.1a7567d7@bree.surriel.com>	 <2c0942db0710220942he5e9199i2e327df3c5676a6a@mail.gmail.com>	 <471CE453.5050208@tiscali.nl> <2c0942db0710221112g7c7d99caj7feb0c2ac5de17e7@mail.gmail.com> <471CF150.9090707@tiscali.nl>
In-Reply-To: <471CF150.9090707@tiscali.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Neem contact op met support@home.nl voor meer informatie
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2007 08:52 PM, Roel Kluin wrote:

> Ray Lee wrote:

>> Arguing intentions is very dangerous. I've written code like that
>> where the intention is to make it simple to turn a printk into a full
>> bug and back and forth during development. At the end of the day, the
>> fact remains that you're changing behavior.
>>
>> Let me turn this around. Do you have an alpha and have you tried out
>> your patch? If not, then I'd suggest turning it into a WARN_ON(1)
>> instead, as in this specific case you're risking turning what was a
>> working system into one that doesn't.
> 
> No, I haven't and, I will change it, but it's included with my other
> changes. see the reply that I'll write shortly for.
> [PATCH retry] return hidden bug and unlock bugs.

Hugely trust inspiring isn't it -- the amount of eyes and comments you'll 
get even on trivial patches like this? This development model is working!

Now if only we'd sometimes get some for non trivial patches as well...

Rene.
