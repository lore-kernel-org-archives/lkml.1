Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbXJ2KJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbXJ2KJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXJ2KJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:09:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58503 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855AbXJ2KJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:09:35 -0400
Date: Mon, 29 Oct 2007 11:09:34 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Markus Elfring <Markus.Elfring@web.de>
cc: linux-kernel@vger.kernel.org
Subject: Re: No module symbols loaded - kernel modules not enabled.
In-Reply-To: <4725B0F9.4000501@web.de>
Message-ID: <Pine.LNX.4.64.0710291109020.26070@fbirervta.pbzchgretzou.qr>
References: <fg2p69$t4p$1@ger.gmane.org> <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr>
 <47250092.5070303@web.de> <Pine.LNX.4.64.0710282310370.4125@fbirervta.pbzchgretzou.qr>
 <4725B0F9.4000501@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Oct 29 2007 11:07, Markus Elfring wrote:
>
>> Like I said, klogd. This seems to be outside the scope of LKML.
>
>Which function instructs the kernel log daemon to record the notice at the beginning of
>the boot process?
>http://chuck.netbsd.sk/source/xref/sysklogd-1.4.1rh/klogd.c
>
>Is the message sent by a printk() call?
>Where is the text "Inspecting" passed?

Like I said, no. This is done by klogd.
