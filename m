Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYBGJ4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYBGJ4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbYBGJzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:55:54 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:49085 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832AbYBGJzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:55:53 -0500
Date: Thu, 7 Feb 2008 10:55:32 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: Richard Purdie <rpurdie@rpsys.net>
cc: kris@krisk.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] leds: Add support for power LED on WRAP systems
In-Reply-To: <1202376355.9519.10.camel@dax.rpnet.com>
Message-ID: <Pine.LNX.4.64.0802071053580.15729@titan.stealer.net>
References: <1202244662-5556-1-git-send-email-sven.wegener@stealer.net>
 <1202376355.9519.10.camel@dax.rpnet.com>
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Spam-Score: -0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Thu, 07 Feb 2008 09:55:48 +0000
	Bayes: 0.3486 Tokens: new, 149; hammy, 1; neutral, 3; spammy, 0.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	* -0.2 BAYES_40 BODY: Bayesian spam probability is 20 to 40%
	*      [score: 0.3486]
X-Spam-Signature: 3addf92a70ebb7789f68a94461956a97375d0ded
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2008, Richard Purdie wrote:

> On Tue, 2008-02-05 at 21:51 +0100, Sven Wegener wrote:
>> WRAP systems have an additional LED. The power LED is normally lit after boot
>> and doesn't serve any other purpose besides showing that the system is powered
>> on. Nevertheless, its state is controllable and we can attach a trigger to it.
>
> There is already a patch queued up to do something like this in the LED
> tree, can you check that does everything you need please?
>
> http://git.o-hand.com/?p=linux-rpurdie-leds;a=shortlog;h=for-mm

It's ok, exactly the same my patch implements.

Sven
