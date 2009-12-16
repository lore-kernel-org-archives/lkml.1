Return-Path: <linux-kernel-owner+w=401wt.eu-S935098AbZLPSdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935098AbZLPSdB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935085AbZLPSc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:32:57 -0500
Received: from fw.wantstofly.org ([80.101.37.227]:45134 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935094AbZLPScz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:32:55 -0500
Date: Wed, 16 Dec 2009 19:01:40 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] ep93xx_eth.c: general cleanup
Message-ID: <20091216180132.GL1819@mail.wantstofly.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090200ECE7@mi8nycmail19.Mi8.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE19090200ECE7@mi8nycmail19.Mi8.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 12:29:38PM -0500, H Hartley Sweeten wrote:

> General cleanup of the ep93xx_eth driver.

Apart from keeping DRV_MODULE_NAME and DRV_MODULE_VERSION, I have
no strong opinion about this one way or the other.  So I guess that
means ACK.
