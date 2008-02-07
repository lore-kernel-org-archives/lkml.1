Return-Path: <linux-kernel-owner+w=401wt.eu-S1757865AbYBGJ0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757865AbYBGJ0Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 04:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYBGJ0M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 04:26:12 -0500
Received: from tim.rpsys.net ([194.106.48.114]:38343 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbYBGJ0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 04:26:10 -0500
Subject: Re: [PATCH] leds: Add support for power LED on WRAP systems
From: Richard Purdie <rpurdie@rpsys.net>
To: Sven Wegener <sven.wegener@stealer.net>
Cc: kris@krisk.org, linux-kernel@vger.kernel.org
In-Reply-To: <1202244662-5556-1-git-send-email-sven.wegener@stealer.net>
References: <1202244662-5556-1-git-send-email-sven.wegener@stealer.net>
Content-Type: text/plain
Date: Thu, 07 Feb 2008 09:25:55 +0000
Message-Id: <1202376355.9519.10.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 21:51 +0100, Sven Wegener wrote:
> WRAP systems have an additional LED. The power LED is normally lit after boot
> and doesn't serve any other purpose besides showing that the system is powered
> on. Nevertheless, its state is controllable and we can attach a trigger to it.

There is already a patch queued up to do something like this in the LED
tree, can you check that does everything you need please?

http://git.o-hand.com/?p=linux-rpurdie-leds;a=shortlog;h=for-mm

Thanks,

Richard

