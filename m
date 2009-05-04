Return-Path: <linux-kernel-owner+w=401wt.eu-S1758883AbZEDSH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758883AbZEDSH0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 14:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757482AbZEDSHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 14:07:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53796
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbZEDSHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 14:07:06 -0400
Date: Mon, 04 May 2009 11:07:01 -0700 (PDT)
Message-Id: <20090504.110701.11718010.davem@davemloft.net>
To: hannes.hering@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Subject: Re: [PATCH 2.6.30-rc5] ehea: fix invalid pointer access
From: David Miller <davem@davemloft.net>
In-Reply-To: <200905041802.30527.hannes.hering@linux.vnet.ibm.com>
References: <200905041802.30527.hannes.hering@linux.vnet.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Date: Mon, 4 May 2009 18:02:30 +0200

> This patch fixes an invalid pointer access in case the receive queue holds no
> pointer to the next skb when the queue is empty.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>
> Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>

Applied, thanks.
