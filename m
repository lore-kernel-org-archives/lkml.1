Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbXKNFPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbXKNFPv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 00:15:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750967AbXKNFPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 00:15:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48494
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750722AbXKNFPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 00:15:41 -0500
Date: Tue, 13 Nov 2007 21:15:40 -0800 (PST)
Message-Id: <20071113.211540.97775009.davem@davemloft.net>
To: olof@lixom.net
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com
Subject: Re: [PATCH] Fix warning for token-ring from sysctl checker
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071113072313.GB16842@lixom.net>
References: <20071113072313.GB16842@lixom.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Tue, 13 Nov 2007 01:23:13 -0600

> As seen when booting ppc64_defconfig:
> 
> sysctl table check failed: /net/token-ring .3.14 procname does not match binary path procname
> 
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Patch applied, thanks Olof.
