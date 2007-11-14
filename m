Return-Path: <linux-kernel-owner+w=401wt.eu-S1764323AbXKNCNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764323AbXKNCNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 21:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757504AbXKNCMr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 21:12:47 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:4682 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078AbXKNCMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 21:12:46 -0500
X-Server-Uuid: 6B5CFB92-F616-4477-B110-55F967A57302
Subject: Re: [PATCH] - [2/15] - remove defconfig ptr comparisons to 0 -
 drivers/net
From: "Michael Chan" <mchan@broadcom.com>
To: "Joe Perches" <joe@perches.com>
cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Garzik" <jgarzik@pobox.com>, "netdev" <netdev@vger.kernel.org>
In-Reply-To: <1195005890.5163.88.camel@localhost>
References: <1195005890.5163.88.camel@localhost>
Date: Tue, 13 Nov 2007 19:00:42 -0800
Message-ID: <1195009242.5677.51.camel@dell>
MIME-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-8)
X-WSS-ID: 6B24861928G22423300-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-11-13 at 18:04 -0800, Joe Perches wrote:
> Remove defconfig ptr comparison to 0
> 
> Remove sparse warning: Using plain integer as NULL pointer
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 

Acked-by: Michael Chan <mchan@broadcom.com>

Thanks.


