Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbXJ0Mlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbXJ0Mlz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 08:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752555AbXJ0Mls
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 08:41:48 -0400
Received: from main.gmane.org ([80.91.229.2]:44095 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752346AbXJ0Mlr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 08:41:47 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: Check handling of kernel build output directory
Date: Sat, 27 Oct 2007 14:41:30 +0200
Message-ID: <472331FA.8050704@web.de>
References: <fft89p$rko$1@ger.gmane.org> <Pine.LNX.4.64.0710271333150.30465@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c7942.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <Pine.LNX.4.64.0710271333150.30465@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> .config should be copied to the output directory.

This copy will usually happen by a command like "make
O=/usr/src/obj/linux/2.6.23.1/x86_64/adjusted silentoldconfig". It seems that something
runs unusual on my openSUSE 10.3 system when an extra output directory was specified.

Regards,
Markus

