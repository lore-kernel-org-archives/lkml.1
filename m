Return-Path: <linux-kernel-owner+w=401wt.eu-S1763871AbXHAMxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763871AbXHAMxN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 08:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757767AbXHAMw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 08:52:59 -0400
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:39562 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756900AbXHAMw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 08:52:58 -0400
Message-ID: <46B0818F.10204@gmail.com>
Date: Wed, 01 Aug 2007 14:50:23 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070716)
MIME-Version: 1.0
To: Indan Zupancic <indan@nul.nu>
CC: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       CK Mailinglist <ck@vds.kolivas.org>, teresa@kvitka.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux Kernel cfs scheduler and xorg kbd
References: <1185827130.26459.16.camel@xtower.fri>    <6bffcb0e0707301549t6be3cd97y27726f5421bb7680@mail.gmail.com>    <20070801064816.GC10134@elte.hu> <p73abtbpk2s.fsf@bingen.suse.de>    <46B06815.10200@gmail.com> <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
In-Reply-To: <46470.81.207.0.53.1185971693.squirrel@secure.samage.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2007 02:34 PM, Indan Zupancic wrote:

> On Wed, August 1, 2007 13:01, Rene Herman wrote:

>> Teresa was already using 2.6.22.1, with CFS (v19.1) patched in, so reverting
>> that would be a matter of patching it out again. She said she wasn't seeing
>> trouble on other kernels though.
>>
>> I was the one who also saw keyboard trouble on 2.6.22.1 without CFS by the
>> way -- and haven't (yet) seen any anymore since patching _in_ CFS v19.1...
> 
> Could the people who had or have keyboard problems try out Dmitry's
> input locking patches, and see if those help: http://lkml.org/lkml/2007/7/24/17
> And if it does, report it to him, either there or here after CCing him.

I'm having trouble reproducing this at will -- it sounded as though Teresa 
had less trouble at least originally. Teresa?

Rene.
