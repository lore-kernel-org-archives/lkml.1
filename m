Return-Path: <linux-kernel-owner+w=401wt.eu-S1760855AbXGVHiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760855AbXGVHiU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 03:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754449AbXGVHiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 03:38:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56490
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752668AbXGVHh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 03:37:59 -0400
Date: Sun, 22 Jul 2007 00:37:58 -0700 (PDT)
Message-Id: <20070722.003758.08651359.davem@davemloft.net>
To: viro@ftp.linux.org.uk
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org, sam@ravnborg.org
Subject: Re: [RFC] Kconfig fun with sparc32/sparc64 rtc drivers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20070722072206.GT21668@ftp.linux.org.uk>
References: <20070722063511.GR21668@ftp.linux.org.uk>
	<20070721.233949.35357470.davem@davemloft.net>
	<20070722072206.GT21668@ftp.linux.org.uk>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ftp.linux.org.uk>
Date: Sun, 22 Jul 2007 08:22:06 +0100

> On Sat, Jul 21, 2007 at 11:39:49PM -0700, David Miller wrote:
> > No objections.
> 
> >From 6fc7f305af19f2020c14a002061a8ce8b7812307 Mon Sep 17 00:00:00 2001
> From: Al Viro <viro@zeniv.linux.org.uk>
> Date: Sun, 22 Jul 2007 03:14:37 -0400
> Subject: [PATCH] deal with rtc/sun_mostek_rtc conflict on sparc32
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied.
