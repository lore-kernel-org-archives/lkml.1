Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZBKVsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZBKVsm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 16:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756537AbZBKVsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 16:48:15 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56071
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755677AbZBKVsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 16:48:13 -0500
Date: Wed, 11 Feb 2009 13:48:07 -0800 (PST)
Message-Id: <20090211.134807.77169123.davem@davemloft.net>
To: hannes.hering@linux.vnet.ibm.com
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org, ossrosch@linux.vnet.ibm.com,
       ossthema@de.ibm.com, raisch@de.ibm.com, themann@de.ibm.com,
       osstklei@de.ibm.com
Subject: Re: [PATCH] ehea: Fix: Remove adapter from adapter list in error
 path
From: David Miller <davem@davemloft.net>
In-Reply-To: <200902111329.02954.hannes.hering@linux.vnet.ibm.com>
References: <200902111329.02954.hannes.hering@linux.vnet.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Date: Wed, 11 Feb 2009 13:29:02 +0100

> Remove adapter from adapter list before freeing data structure in error path.
> 
> Signed-off-by: Hannes Hering <hering2@de.ibm.com>

Applied to net-next-2.6, thanks!
