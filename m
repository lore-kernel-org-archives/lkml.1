Return-Path: <linux-kernel-owner+w=401wt.eu-S1756768AbZETS4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756768AbZETS4p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 14:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755453AbZETS4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 14:56:37 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44059 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483AbZETS4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 14:56:36 -0400
MIME-Version: 1.0
In-Reply-To: <20090519085851.3b8386ed.rdunlap@xenotime.net>
References: <20090519183044.a910aa7a.sfr@canb.auug.org.au> 
	<20090519085851.3b8386ed.rdunlap@xenotime.net>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 20 May 2009 20:56:16 +0200
Message-ID: <ac3eb2510905201156l43ad44d4l358c7f87159fd82e@mail.gmail.com>
Subject: Re: linux-next: Tree for May 19 (devtmpfs build error)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 17:58, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Tue, 19 May 2009 18:30:44 +1000 Stephen Rothwell wrote:

>> Changes since 20090518:
>
> when CONFIG_SHMEM=n:
>
> drivers/built-in.o: In function `dev_get_sb':
> devtmpfs.c:(.text+0x13263b): undefined reference to `shmem_fill_super'

Needed dependencies added.

Thanks,
Kay
