Return-Path: <linux-kernel-owner+w=401wt.eu-S933686AbXJQWex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933686AbXJQWex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 18:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbXJQWep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 18:34:45 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:46838 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757641AbXJQWeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 18:34:44 -0400
Message-ID: <47168DFD.6030900@garzik.org>
Date: Wed, 17 Oct 2007 18:34:37 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>
CC: Hans-Peter Jansen <hpj@urpla.net>, linux-kernel@vger.kernel.org,
       James.Bottomley@steeleye.com, nick.cheng@areca.com.tw
Subject: Re: arcmsr changelog differs from diffs
References: <200710170007.20454.hpj@urpla.net> <20071017005342.GA14212@atjola.homenet> <200710171241.12575.hpj@urpla.net> <20071017130145.GA15918@atjola.homenet>
In-Reply-To: <20071017130145.GA15918@atjola.homenet>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Björn Steinbrink wrote:
> Hi Hans,
> 
> On 2007.10.17 12:41:11 +0200, Hans-Peter Jansen wrote:
>> Dear Björn,
>>
>> Am Mittwoch, 17. Oktober 2007 02:53 schrieb Björn Steinbrink:
>>> And then, if I may guess, James probably just noticed that there were
>>> changes left and commited them (while they were now down to just the
>>> whitespace change), without checking what changes were actually left (no
>>> offense intended). At least I think that git wouldn't cripple the diff
>>> if the changes that James checked in were not already whitespace-only at
>>> the time he commited them, and the git history of his tree seems to
>>> agree.
>> (*) Thanks for the clarification, Björn. What made me stumbling was the 
>> different orginators, while Jeff isn't known with catching attention by 
>> assimilating other peoples contributions. 
> 
> I'm just guessing here, and certainly don't want to blame anyone, but
> Jeff's original patch was from July, while the only date I can find for
> Nick's commit is September 13th. So it was probably Nick who integrated
> Jeff's changes into his commit 

Correct.

It's also quite normal for the maintainer to grab a patch off the list, 
integrate/massage/change it, and then apply it himself.

	Jeff


