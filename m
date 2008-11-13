Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbYKMHf2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbYKMHf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 02:35:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbYKMHfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 02:35:13 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39436
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751235AbYKMHfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 02:35:12 -0500
Date: Wed, 12 Nov 2008 23:35:12 -0800 (PST)
Message-Id: <20081112.233512.181207552.davem@davemloft.net>
To: randy.dunlap@oracle.com
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 9p: restrict RDMA usage
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've applied this to net-2.6 thanks Randy.

I didn't get it earlier because I thought perhaps the
Infiniband folks might want to have picked this one up.
