Return-Path: <linux-kernel-owner+w=401wt.eu-S1759643AbXKCKIA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759643AbXKCKIA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 06:08:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756187AbXKCKHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 06:07:53 -0400
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:47223 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755481AbXKCKHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 06:07:53 -0400
Date: Sat, 3 Nov 2007 11:07:46 +0100
From: Sebastian Siewior <lkml@ml.breakpoint.cc>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.4.24-rc1-git: crash on shutdown/unmount?
Message-ID: <20071103100746.GA24378@Chamillionaire.breakpoint.cc>
References: <200710311917.21441.alistair@devzero.co.uk> <20071101105108.GD5037@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071101105108.GD5037@kernel.dk>
X-Key-Id: FE3F4706
X-Key-Fingerprint: FFDA BBBB 3563 1B27 75C9  925B 98D5 5C1C FE3F 4706
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Jens Axboe | 2007-11-01 11:51:09 [+0100]:

>On Wed, Oct 31 2007, Alistair John Strachan wrote:
>> Hi Jens,
>> 
>> I guessed from the oops that you might have an idea what's causing this oops 
>> on shutdown/unmount. The git version (describe), a screenshot showing the 
>> oops, a config, and dmesg for a booted kernel are available from:
>> 
>> http://devzero.co.uk/~alistair/oops-20071031/
>> 
>> I went back to -rc1 and it still happens there too. If you need any more 
>> information or want me to bisect it, please let me know.
>
>Does this work for you?
Yes, it does. Thanks for working on that. Sorry for the late reply but I
run -ENOINET.

Acked-by: Sebastian Siewior <sebastian@breakpoint.cc>
