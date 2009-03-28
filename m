Return-Path: <linux-kernel-owner+w=401wt.eu-S1761763AbZC1WIB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761763AbZC1WIB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 18:08:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761756AbZC1WHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 18:07:41 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:37857 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761380AbZC1WHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 18:07:40 -0400
X-Greylist: delayed 1478 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Mar 2009 18:07:40 EDT
Subject: Re: 2.6.29 network hosed?
From: Kasper Sandberg <lkml@metanurb.dk>
To: Hua Zhong <hzhong@gmail.com>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
In-Reply-To: <01fc01c9afe9$5ecb43b0$1c61cb10$@com>
References: <01fc01c9afe9$5ecb43b0$1c61cb10$@com>
Content-Type: text/plain
Date: Sat, 28 Mar 2009 22:42:59 +0100
Message-Id: <1238276579.6669.126.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Yes, this is a common issue with network, please search lkml for a post
made by david miller, with subject: "Re: Network died completely in
2.6.29", Message-Id: <20090327.155346.98210435.davem@davemloft.net>

On Sat, 2009-03-28 at 14:08 -0700, Hua Zhong wrote:
> I downloaded 2.6.29 and the network seems to be hosed on my desktop. Normal
> ssh is fine, or light use of network. But whenever I run a perforce
> integration the entire box just becomes completely dead on me. No traces,
> warnings or printks. 100% reproducible. It's a FC4 based system (I know,
> pretty old) for development.
> 
> I only have an USB keyboard attached and it's not recognized after boot, so
> no sysrq traces. Probably I have to upgrade udev? I can still use the
> keyboard on the grub boot menu though.
> 
> If it's a known issue please let me know. I'd be glad to test any patches.
> 
> Hua
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

