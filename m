Return-Path: <linux-kernel-owner+w=401wt.eu-S1757375AbXJRFeZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757375AbXJRFeZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 01:34:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXJRFeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 01:34:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34427
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751182AbXJRFeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 01:34:13 -0400
Date: Wed, 17 Oct 2007 22:34:11 -0700 (PDT)
Message-Id: <20071017.223411.57445764.davem@davemloft.net>
To: ashokrajjb@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Virtual Netdevice
From: David Miller <davem@davemloft.net>
In-Reply-To: <13230720.post@talk.nabble.com>
References: <13230720.post@talk.nabble.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: rajashok <ashokrajjb@gmail.com>
Date: Wed, 17 Oct 2007 22:10:43 -0700 (PDT)

> we are trying to to integrate our ipsec onto linux 2.6 kernel

Why not use the already existing 2.6.x kernel IPSEC stack?
It works quite well.

And for this reason, it is unlikely you will get much help
on these mailing lists in your efforts to replace it with
your own. :-)
