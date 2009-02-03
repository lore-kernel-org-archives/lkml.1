Return-Path: <linux-kernel-owner+w=401wt.eu-S1753812AbZBCHW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812AbZBCHW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 02:22:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbZBCHWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 02:22:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37124
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbZBCHWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 02:22:17 -0500
Date: Mon, 02 Feb 2009 23:22:13 -0800 (PST)
Message-Id: <20090202.232213.202630405.davem@davemloft.net>
To: zbr@ioremap.net
Cc: fweisbec@gmail.com, jmorris@namei.org, lizf@cn.fujitsu.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] connector: create connector workqueue only while
 needed once
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090202110613.GA11413@ioremap.net>
References: <498638ad.1438560a.537e.51b8@mx.google.com>
	<20090202110613.GA11413@ioremap.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <zbr@ioremap.net>
Date: Mon, 2 Feb 2009 14:06:13 +0300

> Looks very good, thanks a lot Frederic.
> Ack.

Applied.
