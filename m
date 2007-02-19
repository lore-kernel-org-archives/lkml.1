Return-Path: <linux-kernel-owner+w=401wt.eu-S932162AbXBSM3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932162AbXBSM3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 07:29:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932194AbXBSM3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 07:29:39 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:56706 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162AbXBSM3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 07:29:39 -0500
Date: Mon, 19 Feb 2007 13:29:59 +0100
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org, davej@codemonkey.org.uk
Subject: "compat_agp_ioctl" [drivers/char/agp/agpgart.ko] undefined!
Message-ID: <20070219122959.GA2612@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


2.6.20-git14

cp arch/powerpc/configs/g5_defconfig ../O-linus/.config
time env LC_ALL=C make -k O=../O-linus 
...
Building modules, stage 2.
MODPOST 127 modules
WARNING: "compat_agp_ioctl" [drivers/char/agp/agpgart.ko] undefined!
make[2]: *** [__modpost] Error 1

