Return-Path: <linux-kernel-owner+w=401wt.eu-S1758797AbZIPKeI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797AbZIPKeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbZIPKeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:34:04 -0400
Received: from brick.kernel.dk ([93.163.65.50]:53879 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044AbZIPKeD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:34:03 -0400
Date: Wed, 16 Sep 2009 12:34:07 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at mm/backing-dev.c:637 bdi_destroy+0x28/0x70()
Message-ID: <20090916103406.GE23126@kernel.dk>
References: <8db1092f0909160242s6856df5ax1bb909272f6c6869@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8db1092f0909160242s6856df5ax1bb909272f6c6869@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 16 2009, Maciej Rutecki wrote:
> Last known good: 2.6.31
> Bad: 26.31-git4
> 
> During reboot i got:
> WARNING: at mm/backing-dev.c:637 bdi_destroy+0x28/0x70()
> 
> Screen picture:
> http://unixy.pl/maciek/download/kernel/2.6.31-git4/shutdown.jpg
> 
> Dmesg:
> http://unixy.pl/maciek/download/kernel/2.6.31-git4/dmesg-2.6.31-git4.txt

Thanks, this one is fixed and just waiting for Linus to pull it in.

-- 
Jens Axboe

