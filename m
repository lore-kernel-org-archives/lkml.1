Return-Path: <linux-kernel-owner+w=401wt.eu-S933290AbZHDSsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290AbZHDSsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 14:48:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933263AbZHDSsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 14:48:41 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38261
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933261AbZHDSsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 14:48:40 -0400
Date: Tue, 04 Aug 2009 11:48:49 -0700 (PDT)
Message-Id: <20090804.114849.263290756.davem@davemloft.net>
To: hannes.hering@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Subject: Re: [PATCH 2.6.31] ehea: Fix napi list corruption on ifconfig down
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908041620.16542.hannes.hering@linux.vnet.ibm.com>
References: <200908041620.16542.hannes.hering@linux.vnet.ibm.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Date: Tue, 4 Aug 2009 16:20:15 +0200

> This patch fixes the napi list handling when an ehea interface is shut down to
> avoid corruption of the napi list.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>

Applied, thanks.
