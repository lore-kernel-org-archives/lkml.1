Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbXD0Jlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbXD0Jlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 05:41:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXD0Jlb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 05:41:31 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:42090 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755524AbXD0Jla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 05:41:30 -0400
Date: Fri, 27 Apr 2007 11:40:40 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Parav K Pandit <Parav_Pandit@mindtree.com>
cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: assembly code in the loadable kernel module
In-Reply-To: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
Message-ID: <Pine.LNX.4.61.0704271139530.506@yvahk01.tjqt.qr>
References: <2C15D00D262B7245B1D8D1799F04D88F052A6F42@mtw01ex01.mindtree.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 27 2007 14:15, Parav K Pandit wrote:
>
>I have written one function in assembly for my kernel module.
>Function is in module3.s file.
>I have added the module3.o file in the object list in the Makefile.
>But it shows compile time warning and following output.
>
>What do I need to do to compile assembly code in my kernel module.

A proper Makefile entry would be a start. Post it, let's find the error.

Jan
-- 
