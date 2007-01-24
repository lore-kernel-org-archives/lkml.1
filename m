Return-Path: <linux-kernel-owner+w=401wt.eu-S965458AbXAXBHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965458AbXAXBHr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 20:07:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965471AbXAXBHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 20:07:47 -0500
Received: from main.gmane.org ([80.91.229.2]:40823 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965458AbXAXBHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 20:07:46 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Oleg Verych <olecom@flower.upol.cz>
Subject: Re: [KBUILD] I don't want initramfs in 2.6.19.1 but usr/ is still processed
Date: Wed, 24 Jan 2007 01:07:21 +0000 (UTC)
Organization: Palacky University in Olomouc, experimental physics department.
Message-ID: <slrnerdcqe.e7s.olecom@flower.upol.cz>
References: <20070103111936.GB18441@DervishD>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@sea.gmane.org
X-Gmane-NNTP-Posting-Host: flower.upol.cz
User-Agent: slrn/0.9.8.1pl1 (Debian)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007-01-03, DervishD wrote:
>
>     Hi all :)

Hallo!

>     I've noticed that, even if I say NO to initramfs (and even ramdisk
> support), the make process wants to GEN usr/initramfs_data.cpio.gz by
> running the scripts/gen_initramfs_list.sh script.
>
>     Why is that script run no matter the initramfs support? Looks like
> it only depends on the contents of CONFIG_INITRAMFS_SOURCE :?

I think reading Documentation/filesystems/ramfs-rootfs-initramfs.txt
will answer your question.

>     Thanks in advance :)
>
>     Raúl Núñez de Arenas Coronado
>
> -- 
> Linux Registered User 88736 | http://www.dervishd.net
> It's my PC and I'll cry if I want to... RAmen!
____

