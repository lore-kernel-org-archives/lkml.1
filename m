Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYGOJKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYGOJKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 05:10:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754355AbYGOJKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 05:10:06 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58531
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753853AbYGOJKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 05:10:05 -0400
Date: Tue, 15 Jul 2008 02:10:04 -0700 (PDT)
Message-Id: <20080715.021004.33973618.davem@davemloft.net>
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       ubraun@linux.vnet.ibm.com, linux390@de.ibm.com,
       linux-s390@vger.kernel.org
Subject: Re: [PATCH] iucv: fix memory leak in cpu hotplug error path.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080715081025.GB22068@localhost.localdomain>
References: <20080715081025.GB22068@localhost.localdomain>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Tue, 15 Jul 2008 17:10:25 +0900

> Fix memory leak in error path in CPU_UP_PREPARE notifier.
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Applied, thank you.
