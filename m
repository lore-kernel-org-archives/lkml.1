Return-Path: <linux-kernel-owner+w=401wt.eu-S1753558AbYCIMzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558AbYCIMzm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 08:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYCIMzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 08:55:31 -0400
Received: from smtp-out02.alice-dsl.net ([88.44.60.12]:55822 "EHLO
	smtp-out02.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbYCIMza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 08:55:30 -0400
To: Pavel Machek <pavel@ucw.cz>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.25-rc4
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org>
	<20080306090029.GA6215@elte.hu> <20080306125929.GD17940@kernel.dk>
	<20080306130643.GB21359@elte.hu> <20080307085341.GA23814@elte.hu>
	<20080308233604.GA3866@ucw.cz>
From: Andi Kleen <andi@firstfloor.org>
Date: 09 Mar 2008 13:55:23 +0100
In-Reply-To: <20080308233604.GA3866@ucw.cz>
Message-ID: <87abl812h0.fsf@basil.nowhere.org>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 09 Mar 2008 12:48:52.0744 (UTC) FILETIME=[EDCFD880:01C881E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek <pavel@ucw.cz> writes:
> 
> How many machines are there in your test farm? Would it be possible to
> make the neccessary scripts available somewhere? I guess I could make
> one or two machines do some automated testing...

You can also use autoboot

ftp://ftp.firstfloor.org/pub/ak/autoboot/autoboot-1.tgz

[hmm I think it's a slightly older version, but should not 
be too difficult to adapt]

These are the scripts we use for automatic testing regularly in Nuernberg.

It's a little different from Ingo's setup I think though and you
really need to use remote controllable power switches for it to work
well [I personally use some cheap USB controlled ones]

-Andi
