Return-Path: <linux-kernel-owner+w=401wt.eu-S1753900AbZESP4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbZESP4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZESP42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:56:28 -0400
Received: from xenotime.net ([72.52.64.118]:52865 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752744AbZESP41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:56:27 -0400
Date: Tue, 19 May 2009 08:58:51 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 19 (devtmpfs build error)
Message-Id: <20090519085851.3b8386ed.rdunlap@xenotime.net>
In-Reply-To: <20090519183044.a910aa7a.sfr@canb.auug.org.au>
References: <20090519183044.a910aa7a.sfr@canb.auug.org.au>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 May 2009 18:30:44 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20090518:


when CONFIG_SHMEM=n:

drivers/built-in.o: In function `dev_get_sb':
devtmpfs.c:(.text+0x13263b): undefined reference to `shmem_fill_super'


---
~Randy
LPC 2009, Sept. 23-25, Portland, Oregon
http://linuxplumbersconf.org/2009/
