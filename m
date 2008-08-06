Return-Path: <linux-kernel-owner+w=401wt.eu-S1764853AbYHFJnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764853AbYHFJnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 05:43:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757284AbYHFJnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 05:43:42 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53723
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752455AbYHFJnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 05:43:41 -0400
Date: Wed, 06 Aug 2008 02:43:41 -0700 (PDT)
Message-Id: <20080806.024341.188166414.davem@davemloft.net>
To: a.beregalov@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: serio/i8042-sparcio.h: fix warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080805211837.GE17320@orion>
References: <20080805211837.GE17320@orion>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexander Beregalov <a.beregalov@gmail.com>
Date: Wed, 6 Aug 2008 01:18:37 +0400

> sparc: i8042-sparcio.h: fix warning
> 
> drivers/input/serio/i8042-sparcio.h:95: warning: 'sparc_i8042_driver'
> defined but not used
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>

Applied, thanks Alexander.
