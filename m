Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbZHZJS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbZHZJS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 05:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756289AbZHZJS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 05:18:56 -0400
Received: from mail.atmel.fr ([81.80.104.162]:41631 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756273AbZHZJSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 05:18:55 -0400
Message-ID: <4A94FDDD.205@atmel.com>
Date: Wed, 26 Aug 2009 11:18:21 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Robert Emanuele <rob@emanuele.us>
CC: =?ISO-8859-1?Q?Eric_B=E9nard?= <eric@eukrea.com>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       "Samuelsson, Ulf" <ulf.samuelsson@atmel.com>
Subject: Re: ARM Git Tree (at91sam9g45 patches)
References: <9f53b4330908251727q1bc1accfk12a9a8d25407791@mail.gmail.com> <4A9488FB.60603@eukrea.com>
In-Reply-To: <4A9488FB.60603@eukrea.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Bénard :
> Hi Robert,
> 
> Robert Emanuele wrote :
>> I'm working with the Atmel at91sam9g45-ekes board which is new.  I was
>> wondering if there was a git tree with the current ARM patches that
>> contains the at91sam9g45 code?  Russell lists "Applied" patches at
>> http://www.arm.linux.org.uk/developer/patches/ .  Where are these
>> applied to?  If there isn't a tree, is there an elegant way to get the
>> latest patch sets that I could apply to Linus's tree?
>>
> you will find the files that you can apply using git am here :
> ftp://ftp.arm.linux.org.uk/pub/armlinux/kernel/git-cur/

Yes, devel branch contains 9g45 patches.

Another place where you can find quite all drivers that I submitted
during the past weeks is in the linux-next tree:

http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary

FYI, I am building a patchset collecting all those submitted patches
against 2.6.30 + Andrew Victor -at91 patch.
It is not finished at the moment but I can send it in private.

I am in contact with Ulf and others for OE and Buildroot inclusion.

This patchset will be available in linux4sam.org in a few weeks.

Best regards,
-- 
Nicolas Ferre

