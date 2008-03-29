Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbYC2XW5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbYC2XW5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 19:22:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYC2XWt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 19:22:49 -0400
Received: from quechua.inka.de ([193.197.184.2]:48606 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751310AbYC2XWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 19:22:48 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: performance differences: "maxcpus=1" vs. "echo 0 > /sys/devices/system/cpu/cpu1/online"
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <16336.23884.qm@web25814.mail.ukl.yahoo.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JfkNq-0005Gh-00@calista.eckenfels.net>
Date: Sun, 30 Mar 2008 00:22:46 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <16336.23884.qm@web25814.mail.ukl.yahoo.com> you wrote:
> Is here any method to get the exact same behaviour of
> "maxcpus=1" with disabling the second core only

I dont have much insight, but I do remember some java performance problems
on Multi-Core with some Dell Desktops. I think they had been fixed with a
Bios upgrade. Sorry I dont remeber the chip and revision details anymore. I
just felt reminded, because MAXCPU=1 helped back then, also.

Gruss
Bernd
y
