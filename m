Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbZACKZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbZACKZh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbZACKZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:25:29 -0500
Received: from proxy2.bredband.net ([195.54.101.72]:51609 "EHLO
	proxy2.bredband.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbZACKZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:25:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqM4AEPMXklR4F8bPGdsb2JhbACBbJIHAQEBATUBtheFcg
Message-ID: <495F3D11.4080005@zappa.cx>
Date: Sat, 03 Jan 2009 11:25:21 +0100
From: Andreas Sundstrom <sunkan@zappa.cx>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.28 ext4, xen and lvm volume becomes ro after snapshot
References: <20081226140721.GN9871@mit.edu> <4954FB62.4090306@zappa.cx>	<20081226182145.GP9871@mit.edu> <495526F6.9040704@zappa.cx>	<20081226193307.GA2138@mit.edu> <495553EB.6030604@zappa.cx>	<20081227030632.GA3539@mit.edu> <4955F338.4020509@zappa.cx>	<20090102031110.GF17821@mit.edu> <20090102092902.6p7echfdgkos40ss@zappa.cx>	<20090102141014.GB4758@mit.edu>
In-Reply-To: <20090102141014.GB4758@mit.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Theodore Tso <tytso@mit.edu>:

> On Fri, Jan 02, 2009 at 09:29:02AM +0100, Andreas Sundstrom wrote:
>>
>> Well, the patch didn't work when I did "patch -i ext4.patch -p1" but I
>> did it manually and the code compiles and works fine.
>
> The patch assumed some whitespace cleanups earlier in the ext4 patch
> queue, which is probably why you had to apply the patch by hand.
> Thanks for trying it out!!

I see.. no problem..

>
> May I add:
>
> Tested-by: Andreas Sundstrom <sunkan@zappa.cx>
>
> To the patch commit log?  We've been trying trying to give credit to
> those people who work with kernel developers to test fixes, but given
> that it does add peoples' e-mail addresses, it's something I always
> ask permission to do if that person hasn't agreed to this sort of
> thing already.

Yes that is ok

Thank you for looking in to the issue

/Andreas
