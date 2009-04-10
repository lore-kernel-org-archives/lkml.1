Return-Path: <linux-kernel-owner+w=401wt.eu-S938640AbZDJWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938640AbZDJWJU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936052AbZDJWIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:08:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49832 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938153AbZDJWIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:08:45 -0400
Date: Fri, 10 Apr 2009 15:06:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org
Subject: Re: [PATCH 2/4] [MTD] Add MEMERASE64 ioctl for >4GiB devices
Message-Id: <20090410150614.b2c6f7ab.akpm@linux-foundation.org>
In-Reply-To: <a95a62fe0904082252h41afa872j2ef6fb9d1d76dc27@mail.gmail.com>
References: <a95a62fe0904082252h41afa872j2ef6fb9d1d76dc27@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 22:52:28 -0700
Kevin Cernekee <kpc.mtd@gmail.com> wrote:

> Subject: [PATCH 2/4] [MTD] Add MEMERASE64 ioctl for >4GiB devices

triviata:

The text inside [] is usually removed by the patch recipient - the []
denotes transient information such as "patch" and the kernel version,
etc.

The preferred form for patch titles is

	subsytem-identifier: what-i-did-to-it

so this patch should have been

	mtd: add MEMERASE64 ioctl for >4GiB devices

> 
> @@ -427,20 +428,32 @@ static int mtd_ioctl(struct inode *inode, struct
> file *file,

Your email client is wordwrapping the text.
