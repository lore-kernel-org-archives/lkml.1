Return-Path: <linux-kernel-owner+w=401wt.eu-S1759149AbXENDw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759149AbXENDw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbXENDwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:52:20 -0400
Received: from gw.goop.org ([64.81.55.164]:42270 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754655AbXENDwT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:52:19 -0400
Message-ID: <4647DCF6.9070305@goop.org>
Date: Sun, 13 May 2007 20:52:22 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: 2.6.22-rc1: loop.c
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <20070513205121.GA5814@martell.zuzino.mipt.ru>
In-Reply-To: <20070513205121.GA5814@martell.zuzino.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> 2. After (so far) manual invocations of mknod and mount -a, lockdep spit
>    the following:
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
>   

Al has a patch to fix this (haven't tested it myself yet though).

    J
