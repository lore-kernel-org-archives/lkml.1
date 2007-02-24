Return-Path: <linux-kernel-owner+w=401wt.eu-S1752261AbXBXMhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbXBXMhT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:37:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752263AbXBXMhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:37:19 -0500
Received: from raven.upol.cz ([158.194.120.4]:59934 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbXBXMhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:37:18 -0500
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-kernel-list <linux-kernel@vger.kernel.org>,
       Pete Zaitcev <zaitcev@redhat.com>
Subject: Re: [PATCH] USB Elan FTDI: check for workqueue creation v2
In-Reply-To: <20070224074115.GB10139@cvg>
References: <20070224074115.GB10139@cvg>
Date: Sat, 24 Feb 2007 13:46:44 +0100
Message-Id: <E1HKwIW-0005OS-Nw@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Cyrill Gorcunov
> Newsgroups: gmane.linux.kernel
> Subject: bss zeroing ([PATCH] USB Elan FTDI: check for workqueue creation v2)
> Date: Sat, 24 Feb 2007 10:41:15 +0300
[]
> Btw, Pete, you are right! C99 ANSI standart says that static pointer
> if it not initialized explicitly has to be set to NULL by compiler ;)
> Thanks a lot for comments and Ack the patch please.

Are you sure about "by compiler"? I mean, why not by OS, in case of uCs
by code/data memory image generator?

____
