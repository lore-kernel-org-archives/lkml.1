Return-Path: <linux-kernel-owner+w=401wt.eu-S1760617AbXELTiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617AbXELTiX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 15:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756653AbXELTiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 15:38:16 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:58950 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874AbXELTiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 15:38:15 -0400
Date: Sat, 12 May 2007 21:37:27 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Jens Axboe <jens.axboe@oracle.com>
cc: linux-kernel@vger.kernel.org, mchehab@infradead.org
Subject: Re: default y idiocy
In-Reply-To: <20070512192726.GQ4629@kernel.dk>
Message-ID: <Pine.LNX.4.61.0705122135510.9570@yvahk01.tjqt.qr>
References: <20070512182343.GO4629@kernel.dk> <Pine.LNX.4.61.0705122121340.9570@yvahk01.tjqt.qr>
 <20070512192726.GQ4629@kernel.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12 2007 21:27, Jens Axboe wrote:
>On Sat, May 12 2007, Jan Engelhardt wrote:
>> 
>> On May 12 2007 20:23, Jens Axboe wrote:
>> >Hi,
>> >
>> >This has bothered me for a long time, and it just seems to be getting
>> >worse. Can people please STOP defaulting non-essential stuff to 'y'?
>> >Grrr.
>> 
>> http://lkml.org/lkml/2007/5/8/76
>
>Sorry, I don't buy that reason at all - it's a short term advantage,
>causing long term pain. It's not what we have done in the past, don't
>start doing crap like that now.

Right, I shall create some patches to revert that and send them off
to Linus ASAP.


	Jan
-- 
