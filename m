Return-Path: <linux-kernel-owner+w=401wt.eu-S1758803AbYD3AxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803AbYD3AxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 20:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755694AbYD3AxI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 20:53:08 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:49269 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153AbYD3AxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 20:53:07 -0400
Date: Tue, 29 Apr 2008 17:49:39 -0700 (PDT)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: David Brownell <david-b@pacbell.net>
cc: Ben Nizette <bn@niasdigital.com>, lkml <linux-kernel@vger.kernel.org>,
       hartleys <hartleys@visionengravers.com>,
       Mike Frysinger <vapier.adi@gmail.com>, Bryan Wu <cooloney@kernel.org>
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
In-Reply-To: <200804291456.52889.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.64.0804291746410.20563@t2.domain.actdsltmp>
References: <200804281239.51729.david-b@pacbell.net> <1209472526.311.50.camel@moss.renham>
 <Pine.LNX.4.64.0804291022190.15041@t2.domain.actdsltmp>
 <200804291456.52889.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008, David Brownell wrote:
>
>> If anything,
>> the parsing code is simpler than what David has.
>
> Apples vs oranges.  Use the same command syntax if you're going
> to make comparisons; I can save even more with "+export/-unexport"
> syntax.  For comparable syntax, your stuff *IS* bigger.

If the code you wrote it not too complex, then why is the code I wrote, which
is not larger, too complex?


>> David's code for parsing the control file plus code for generating a mapping
>> range file would certainly be larger.
>
> The #3 option presumes some file listing chips and ranges too,
> since GPIOs are exported only on demand.  Ditto #2 and #4...

You never answered how one was supposed to get the proper device from a
script.
