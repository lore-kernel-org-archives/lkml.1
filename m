Return-Path: <linux-kernel-owner+w=401wt.eu-S965084AbXHNFv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965084AbXHNFv7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:51:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S938115AbXHNFu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:50:29 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52068 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440AbXHNFuZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:50:25 -0400
Message-ID: <46C1429D.4080809@garzik.org>
Date: Tue, 14 Aug 2007 01:50:21 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: mikep@linuxtr.net, netdev@vger.kernel.org, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/tokenring: Convert to generic boolean
References: <20070814000543.13576.62289.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20070814000543.13576.62289.sendpatchset@thinktank.campus.ltu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Knutsson wrote:
> Convert to generic boolean
> 
> Signed-off-by: Richard Knutsson <ricknu-0@student.ltu.se>
> ---
> Compile-tested with all(yes|mod|no)config on x86(|_64) & sparc(|64)
> Diffed against Linus' git-tree.
> Sent 2007-05-01, no replys

applied


