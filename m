Return-Path: <linux-kernel-owner+w=401wt.eu-S1754886AbYCaC7P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbYCaC7P (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2008 22:59:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753017AbYCaC7F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Mar 2008 22:59:05 -0400
Received: from quechua.inka.de ([193.197.184.2]:37848 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752813AbYCaC7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2008 22:59:04 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: RFC:   Writing Solaris Device Drivers in Java
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <47F0491F.4050804@gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1JgAEe-0006hb-00@calista.eckenfels.net>
Date: Mon, 31 Mar 2008 04:59:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <47F0491F.4050804@gmail.com> you wrote:
> (Windows/MacOS/Linux/BSD etc).   Ie, imagine using a drivers written for 
> the Solaris in Linux, won't it be cool?

I think the device driver reuse between the various C-kernels is pretty big.
For efficiency and since the low level stuff is a major part of device
drivers, I cant see a Java solution. I guess we would see drivers in Forth before :)

Gruss
Bernd
