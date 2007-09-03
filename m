Return-Path: <linux-kernel-owner+w=401wt.eu-S1755277AbXICJj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbXICJj6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 05:39:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751306AbXICJjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 05:39:48 -0400
Received: from lucidpixels.com ([75.144.35.66]:54464 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751093AbXICJjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 05:39:47 -0400
Date: Mon, 3 Sep 2007 05:39:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Xavier Bestel <xavier.bestel@free.fr>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-raid@vger.kernel.org
Subject: Re: very very strange simultaneous RAID resync on sep 2, 01:06 CEST
 (+2)
In-Reply-To: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
Message-ID: <Pine.LNX.4.64.0709030538550.6070@p34.internal.lan>
References: <1188806170.1131.479.camel@frg-rhel40-em64t-04>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Sep 2007, Xavier Bestel wrote:

> Hi,
>
> I have a server running with RAID5 disks, under debian/stable, kernel
> 2.6.18-5-686. Yesterday the RAID resync'd for no apparent reason,
> without even mdamd sending a mail to warn about that:

This is normal, you probably are running Debian(?) or a Debian-derived
distribution and the checkarray script runs once a month by default I
believe.

Justin.

