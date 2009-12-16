Return-Path: <linux-kernel-owner+w=401wt.eu-S1762820AbZLPScG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762820AbZLPScG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:32:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762784AbZLPScF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:32:05 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:45130 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623AbZLPScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:32:04 -0500
Date: Wed, 16 Dec 2009 19:32:00 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH] ep93xx_eth.c: general cleanup
Message-ID: <20091216183200.GN1819@mail.wantstofly.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090200ECE7@mi8nycmail19.Mi8.com> <20091216180132.GL1819@mail.wantstofly.org> <BD79186B4FD85F4B8E60E381CAEE19090200ED01@mi8nycmail19.Mi8.com> <20091216180849.GM1819@mail.wantstofly.org> <BD79186B4FD85F4B8E60E381CAEE19090200ED0C@mi8nycmail19.Mi8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200ED0C@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 01:18:13PM -0500, H Hartley Sweeten wrote:

> V3 - Change pr_fmt() as suggested by Joe Perches
>      Don't remove DRV_MODULE_NAME and DRV_MODULE_VERSION
>      Don't remove the message in ep93xx_eth_init_module()

That's not what I meant, but alright, as you prefer.
