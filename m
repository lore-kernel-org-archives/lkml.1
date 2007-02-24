Return-Path: <linux-kernel-owner+w=401wt.eu-S1752257AbXBXMbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbXBXMbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 07:31:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbXBXMbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 07:31:33 -0500
Received: from raven.upol.cz ([158.194.120.4]:59718 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257AbXBXMbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 07:31:32 -0500
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Organization: Palacky University in Olomouc, experimental physics department.
Subject: ioctls.h (Re: [PATCH][RFC] Make asm-generic/ioctl.h extensible by adding conditionals.)
In-Reply-To: <Pine.LNX.4.64.0702240641520.15087@CPE00045a9c397f-CM001225dbafb6>
References: <Pine.LNX.4.64.0702240641520.15087@CPE00045a9c397f-CM001225dbafb6>
Date: Sat, 24 Feb 2007 13:41:00 +0100
Message-Id: <E1HKwCy-0005OM-FW@flower>
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> From: "Robert P. J. Day"
> Newsgroups: gmane.linux.kernel
> Subject: [PATCH][RFC] Make asm-generic/ioctl.h extensible by adding conditionals.
> Date: Sat, 24 Feb 2007 06:45:20 -0500 (EST)

>   as a followup to my earlier post, is it worth making this change to
> allow at least a couple arch-specific ioctl.h files to be massively
> simplified?

And i wonder, why there is no generic ioctls.h, hm?

____
