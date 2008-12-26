Return-Path: <linux-kernel-owner+w=401wt.eu-S1752782AbYLZW3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbYLZW3d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 17:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751895AbYLZW3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 17:29:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52811
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751292AbYLZW3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 17:29:21 -0500
Date: Fri, 26 Dec 2008 14:29:23 -0800 (PST)
Message-Id: <20081226.142923.63754891.davem@davemloft.net>
To: donash4@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: qdisc requeue stats
From: David Miller <davem@davemloft.net>
In-Reply-To: <be9d10f20812261414n30d8061bkf2af90d3cbca8e95@mail.gmail.com>
References: <be9d10f20812261414n30d8061bkf2af90d3cbca8e95@mail.gmail.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Don Ash" <donash4@gmail.com>
Date: Sat, 27 Dec 2008 00:14:03 +0200

> Is there a way to see q->qstats.requeues statistics
> (dev_requeue_skb()) ? I tried tc tool but it does not
> show it...

You'll have better luck with this question on the networking
developer list, which has been added to the CC:
