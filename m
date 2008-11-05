Return-Path: <linux-kernel-owner+w=401wt.eu-S1755959AbYKEJhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755959AbYKEJhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 04:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753941AbYKEJhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 04:37:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47118
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbYKEJhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 04:37:05 -0500
Date: Wed, 05 Nov 2008 01:36:41 -0800 (PST)
Message-Id: <20081105.013641.167946252.davem@davemloft.net>
To: randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, ericvh@gmail.com
Subject: Re: [PATCH] net/9p: fix printk format warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081104204646.977cecad.randy.dunlap@oracle.com>
References: <20081104204646.977cecad.randy.dunlap@oracle.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 4 Nov 2008 20:46:46 -0800

> Fix printk format warnings in net/9p.
> Built cleanly on 7 arches.

Applied, thanks Randy.

Please post future networking patches at least CC:'d to netdev so that
they get logged and tracked at:

	http://patchwork.ozlabs.org/user/todo

Thanks.
