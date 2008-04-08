Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbYDHVlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbYDHVlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 17:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752590AbYDHVk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 17:40:59 -0400
Received: from quechua.inka.de ([193.197.184.2]:39361 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751673AbYDHVk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 17:40:58 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: DRDY errors again
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <20080408171311.69441c8b@werewolf>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JjLYm-0002d7-00@calista.eckenfels.net>
Date: Tue, 08 Apr 2008 23:40:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <20080408171311.69441c8b@werewolf> you wrote:
> Well, I'm getting all those errors on SATA disks again. I have just returned
> one thinkin it was faulty. But I don't buy I got all the bad drives in the
> store...

It could be, that it is a driver problem, but just to be sure:

I would recommend to run the vendors diag program again, and also look at
the s.m.a.r.t output. (Typically you need an error code to return the drive,
did you had one for your last return?)

Besides the disk it could also be a voltage problem (voltage control on
mainboard or power supply). I asume you ruled out thermal problems...

Gruss
Bernd
