Return-Path: <linux-kernel-owner+w=401wt.eu-S938892AbXHIGME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938892AbXHIGME (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 02:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761438AbXHIGLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 02:11:51 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:55834
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754917AbXHIGLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 02:11:50 -0400
Date: Wed, 08 Aug 2007 23:11:44 -0700 (PDT)
Message-Id: <20070808.231144.22645124.davem@davemloft.net>
To: ossthema@de.ibm.com
Cc: raisch@de.ibm.com, themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       gallatin@myri.com, jeff@garzik.org, stefan.roscher@de.ibm.com,
       netdev@vger.kernel.org
Subject: Re: [PATCH 0/1] lro: Generic Large Receive Offload for TCP traffic
From: David Miller <davem@davemloft.net>
In-Reply-To: <200708031441.14780.ossthema@de.ibm.com>
References: <200708031441.14780.ossthema@de.ibm.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan-Bernd Themann <ossthema@de.ibm.com>
Date: Fri, 3 Aug 2007 14:41:14 +0200

> I think this patch could be the final version for now. It has been tested
> on two platforms (power and x86_64) and works very well.

I checked in the LRO patch and the two sample driver ports
to net-2.6.24, thanks!
