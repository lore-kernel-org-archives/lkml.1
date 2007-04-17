Return-Path: <linux-kernel-owner+w=401wt.eu-S964960AbXDQOLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964960AbXDQOLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 10:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964988AbXDQOLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 10:11:18 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:59972 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964960AbXDQOLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 10:11:17 -0400
Date: Tue, 17 Apr 2007 15:14:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Nikita Danilov <nikita@clusterfs.com>
Cc: Ignatich <ignatich@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: ZFS with Linux: An Open Plea
Message-ID: <20070417151407.65cda29e@the-village.bc.nu>
In-Reply-To: <17954.7753.258414.213430@gargle.gargle.HOWL>
References: <462111F8.1060700@gmail.com>
	<17954.7753.258414.213430@gargle.gargle.HOWL>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Apr 2007 16:44:57 +0400
Nikita Danilov <nikita@clusterfs.com> wrote:

> Ignatich writes:
>  > You might want to look at this discussion:
>  > http://mail.opensolaris.org/pipermail/zfs-discuss/2007-April/027041.html
> 
> Licenses involved cover file system _code_, rather than storage format
> that is openly specified. Just stand up and implement driver for zfs
> format from scratch under whatever license you want. This is exactly how
> Linux supports "foreign" file systems (ntfs, fat, etc.).

That leaves all the patents Sun have filed to prevent anyone doing so.
