Return-Path: <linux-kernel-owner+w=401wt.eu-S965269AbXHNFwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965269AbXHNFwz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 01:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S942472AbXHNFug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 01:50:36 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:52077 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S940527AbXHNFud (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 01:50:33 -0400
Message-ID: <46C142A6.1080707@garzik.org>
Date: Tue, 14 Aug 2007 01:50:30 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Richard Knutsson <ricknu-0@student.ltu.se>
CC: philb@gnu.org, netdev@vger.kernel.org, kernel-janitors@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/3c505: Convert to generic boolean
References: <20070813234814.13259.28175.sendpatchset@thinktank.campus.ltu.se>
In-Reply-To: <20070813234814.13259.28175.sendpatchset@thinktank.campus.ltu.se>
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


