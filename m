Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbZBILp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbZBILp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:45:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752306AbZBILpN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:45:13 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:40506 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZBILpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:45:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xCV7IMtYq59Wt4tSODEXL53cYlT/z0fsM40AAmd7y3gKn+FgHnK5CDaFUt54dPGPOu
         PDEYqIlfJhb7OtllzpC1ee+HxbkQDMlycCLiLrzjCEQ/KXD7TbRgNlTDUaQspZMuyLwH
         vjEpa9Z4zCgLsjeNlpUYUxGh7LdhdS1UKFGBY=
MIME-Version: 1.0
In-Reply-To: <20090209095803.GD4358@atrey.karlin.mff.cuni.cz>
References: <1233967681-6378-1-git-send-email-giuseppe.bilotta@gmail.com>
	 <498D9F02.9000107@tremplin-utc.net>
	 <cb7bb73a0902071559w70b3367el9471db894872257f@mail.gmail.com>
	 <20090209094748.GC4358@atrey.karlin.mff.cuni.cz>
	 <cb7bb73a0902090153q30a5337bj45d41a3e3919e189@mail.gmail.com>
	 <20090209095803.GD4358@atrey.karlin.mff.cuni.cz>
Date: Mon, 9 Feb 2009 12:45:09 +0100
Message-ID: <cb7bb73a0902090345y4ef5d544ta374ee96791a80df@mail.gmail.com>
Subject: Re: [PATCH] lis3lv02d: add axes knowledge of HP Pavilion dv5 models
From: Giuseppe Bilotta <giuseppe.bilotta@gmail.com>
To: Pavel Machek <pavel@suse.cz>
Cc: "?ric Piel" <eric.piel@tremplin-utc.net>, linux-kernel@vger.kernel.org,
       Palatis Tseng <palatis@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 9, 2009 at 10:58 AM, Pavel Machek <pavel@suse.cz> wrote:
>> 2009/2/9 Pavel Machek <pavel@suse.cz>:
>> > Ok, at my machine it fluctuates around 1K when sitting on the desk,
>> > and maximum range is about 13-15K. So your values seem little too noisy.
>>
>> I suspected as much. Do you think this is a hardware problem, or
>> something that can be worked around in software? Or maybe I just leave
>> in a very shaky neighborohood (although there's little or no car
>> traffic around here) ...
>
> I'd say that the driver is way too new to suspect hardware
> problems. Could you try the new version from -mm? It does very minimum
> setup, as recommended by HP...

I can try, but I have never worked with the -mm tree, so I don't even
know where to get it. Is there a webpage or archived email I can read
to understand how to get and build the -mm tree? Is it git-tracked? Or
can I just get your patches for -mm and apply them on top of the
current git?

I will try this patch
http://lkml.indiana.edu/hypermail/linux/kernel/0901.2/00164.html in
the mean time, in case that's the patch which is in -mm.

-- 
Giuseppe "Oblomov" Bilotta
