Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbXJ1Vfy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbXJ1Vfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:35:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbXJ1Vfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:35:46 -0400
Received: from main.gmane.org ([80.91.229.2]:54589 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848AbXJ1Vfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:35:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Markus Elfring <Markus.Elfring@web.de>
Subject: Re: No module symbols loaded - kernel modules not enabled.
Date: Sun, 28 Oct 2007 22:35:14 +0100
Message-ID: <47250092.5070303@web.de>
References: <fg2p69$t4p$1@ger.gmane.org> <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p508c416a.dip.t-dialin.net
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
In-Reply-To: <Pine.LNX.4.64.0710282146440.17164@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> This message is added by klogd, and it is independent of CONFIG_KALLSYMS.
> (Since I do have KALLSYMS=y while also getting that message. I suppose
> it is because CONFIG_DEBUG_INFO=n)

I could not find the message text in my kernel source directory so far. I had also no luck
with a cross reference like "http://lxr.linux.no/search".
Which source code is responsible for the notice?

Regards,
Markus

