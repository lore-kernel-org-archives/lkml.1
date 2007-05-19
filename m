Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbXESQjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbXESQjF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 12:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXESQi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 12:38:56 -0400
Received: from quechua.inka.de ([193.197.184.2]:33151 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXESQiz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 12:38:55 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: ht CPU flag
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <Pine.LNX.4.64.0705191328090.31481@ns.armcci.am>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1HpRxF-0001Ee-00@calista.eckenfels.net>
Date: Sat, 19 May 2007 18:38:53 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <Pine.LNX.4.64.0705191328090.31481@ns.armcci.am> you wrote:
> To authors of /proc/cpuinfo:
> 
> Plz, fix stepping identification:

It might be a bug in the kernel code, however it is pretty unlikely: It just
reads what the CPU reports. You have an odd chip, nothing what the kernel
can do about. I see "family 15, model 2, stepping 4" usually beeing a P4
2.4GHz CPU. Maybe thats one of those relabling cases.

The information you list is a dual-cpu with HT configuration.

You could give us the output of any of your windows tools, but I am quite
sure they will report the same thing.

Greetings
Bernd
