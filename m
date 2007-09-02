Return-Path: <linux-kernel-owner+w=401wt.eu-S933655AbXIBAty@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933655AbXIBAty (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 20:49:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932781AbXIBAtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 20:49:46 -0400
Received: from barikada.upol.cz ([158.194.242.200]:46778 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932726AbXIBAtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 20:49:46 -0400
To: Chris Mason <chris.mason@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] seekwatcher v0.3 IO graphing an animation
In-Reply-To: <20070727212057.174ef1ca@think.oraclecorp.com>
References: <20070727212057.174ef1ca@think.oraclecorp.com>
Date: Sun, 2 Sep 2007 03:04:43 +0200
Message-Id: <E1IRdtL-0002Pl-N7@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Fri, 27 Jul 2007 21:20:57 -0400
>
[]
> Here's a sample of the smoother graphs (creating 20 kernel trees):
>
> http://oss.oracle.com/~mason/seekwatcher/ext3_vs_btrfs_vs_xfs.png

It seems, that making log for XFS on different physical device can
boost performance. Will it be reliable, is a question, isn't it?
____
