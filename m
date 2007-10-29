Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbXJ2Kpu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbXJ2Kpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 06:45:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752016AbXJ2Kpn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 06:45:43 -0400
Received: from main.gmane.org ([80.91.229.2]:56516 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXJ2Kpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 06:45:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: No module symbols loaded - kernel modules not enabled.
Date: Mon, 29 Oct 2007 11:44:24 +0100
Message-ID: <4725B988.9000806@web.de>
References: <fg2p69$t4p$1@ger.gmane.org> <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr> <47250092.5070303@web.de> <Pine.LNX.4.64.0710282310370.4125@fbirervta.pbzchgretzou.qr> <4725B0F9.4000501@web.de> <Pine.LNX.4.64.0710291109020.26070@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c5e7b.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <Pine.LNX.4.64.0710291109020.26070@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Like I said, no. This is done by klogd.

Now I have found the notice "Inspecting" in the function "CheckMapVersion".
http://chuck.netbsd.sk/source/xref/sysklogd-1.4.1rh/ksym.c

I am interested to look at a source file that contains the dicussed error message. Does
anybody know a development package for the kernel log daemon?

Regards,
Markus

