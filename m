Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYGAAMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYGAAMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 20:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753696AbYGAAME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 20:12:04 -0400
Received: from quechua.inka.de ([193.197.184.2]:49953 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173AbYGAAMD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 20:12:03 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: Higher than expected disk write(2) latency
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <48695C20.6050704@fastmq.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1KDTTT-0003dQ-00@calista.eckenfels.net>
Date: Tue, 01 Jul 2008 02:11:59 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In article <48695C20.6050704@fastmq.com> you wrote:
> Yes, that's one thing we want to do. However, we cannot assume that 
> every user will have SSD, thus we should try to get the best latencies 
> possible even on standard HD.

In that case controller (SAN) based write back cache as well as Striping
helps a bit.

Gruss
Bernd
