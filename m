Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbXFDBTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbXFDBTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbXFDBTZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:19:25 -0400
Received: from quechua.inka.de ([193.197.184.2]:45568 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750750AbXFDBTY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:19:24 -0400
From: Bernd Eckenfels <ecki@lina.inka.de>
To: linux-kernel@vger.kernel.org
Subject: Re: slow open() calls and o_nonblock
Organization: Private Site running Debian GNU/Linux
In-Reply-To: <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com>
X-Newsgroups: ka.lists.linux.kernel
User-Agent: tin/1.7.8-20050315 ("Scalpay") (UNIX) (Linux/2.6.13.4 (i686))
Message-Id: <E1Hv1EA-000399-00@calista.eckenfels.net>
Date: Mon, 04 Jun 2007 03:19:22 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In article <e7ca40f70706031152q4e9630aq3c29623bd56fe0e5@mail.gmail.com> you wrote:
> (ps.  having come from the socket side of the fence, its incredibly
> frustrating to be unable to poll() or epoll regular file FDs --
> Especially knowing that the kernel is translating them into a TCP
> socket to do NFS anyway.  Please add regular files to epoll and give
> me a way to do the opens in the same fasion as connects!)

You might want to use Windows? :) 

Gruss
Bernd
