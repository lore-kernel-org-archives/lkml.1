Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYBDJRg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYBDJRg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 04:17:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755157AbYBDJRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 04:17:20 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754891AbYBDJRT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 04:17:19 -0500
Message-ID: <47A6D80C.9070204@redhat.com>
Date: Mon, 04 Feb 2008 10:17:00 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Christoph Anton Mitterer <calestyo@scientia.net>
CC: linux-kernel@vger.kernel.org, dm-crypt@saout.de
Subject: Re: data corruption with dmcrypt/LUKS
References: <1202050237.3200.33.camel@fermat.scientia.net>	 <47A63AD3.6080501@redhat.com> <1202085829.3223.19.camel@fermat.scientia.net>
In-Reply-To: <1202085829.3223.19.camel@fermat.scientia.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Anton Mitterer wrote:
> On Sun, 2008-02-03 at 23:06 +0100, Milan Broz wrote:
...
>>> 2) The second bug happens only rarely and leads to a panic.
>>> Unfortunately it's difficult to reproduce, but it always happened when I
>>> mkfs.ext3 on the /dev/mapper/sda2.
>>> There's a stack-trace printed which clearly involves some dmcrypt
>>> lines...
>> But no stack trace attached here... please attach it.
> Unfortunately I don't have one,... nothing was written to the logs and I
> forgot to write it up :-/
> 
> 
> 
>> It can be known bug which was fixed in stable version some time ago
>> see http://lkml.org/lkml/2007/7/20/211
> Uhm but that patch should be part of 2.6.24, shouldn't it?

Yes, so if you hit this with 2.6.24 too is very important to sent OOps
log to identify problem (or link to screen snapshot, digital camera
snapshot or so).

...
> btw: What's about the dmcrypt mailing list,.. I've tried to subscribe
> but no answers, and I get not posts (not even my owns).

This is another story...
I hope that someone with admin rights will fix it (Christophe ?)

Milan
--
mbroz@redhat.com

