Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbXJ2KI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbXJ2KI0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752757AbXJ2KIT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:08:19 -0400
Received: from main.gmane.org ([80.91.229.2]:38989 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbXJ2KIS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:08:18 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: No module symbols loaded - kernel modules not enabled.
Date: Mon, 29 Oct 2007 11:07:53 +0100
Message-ID: <4725B0F9.4000501@web.de>
References: <fg2p69$t4p$1@ger.gmane.org> <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr> <47250092.5070303@web.de> <Pine.LNX.4.64.0710282310370.4125@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c5e7b.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <Pine.LNX.4.64.0710282310370.4125@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Like I said, klogd. This seems to be outside the scope of LKML.

Which function instructs the kernel log daemon to record the notice at the beginning of
the boot process?
http://chuck.netbsd.sk/source/xref/sysklogd-1.4.1rh/klogd.c

Is the message sent by a printk() call?
Where is the text "Inspecting" passed?

Regards,
Markus

