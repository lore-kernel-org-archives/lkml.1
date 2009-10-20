Return-Path: <linux-kernel-owner+w=401wt.eu-S1751256AbZJTIJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbZJTIJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 04:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZJTIJV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 04:09:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59697
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751029AbZJTIJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 04:09:20 -0400
Date: Tue, 20 Oct 2009 01:09:43 -0700 (PDT)
Message-Id: <20091020.010943.162563535.davem@davemloft.net>
To: acme@redhat.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Re: linux-next: net tree build warnings
From: David Miller <davem@davemloft.net>
In-Reply-To: <20091017021024.GI25141@ghostprotocols.net>
References: <20091014153450.3110e34c.sfr@canb.auug.org.au>
	<20091014.151137.30359959.davem@davemloft.net>
	<20091017021024.GI25141@ghostprotocols.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Fri, 16 Oct 2009 23:10:24 -0300

> Subject: [PATCH] net: Avoid compiler warning for mmsghdr when CONFIG_COMPAT is not selected
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>

Applied, please CC: networking patches to netdev in the future.

Thanks.
