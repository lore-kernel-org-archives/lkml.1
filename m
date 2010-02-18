Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881Ab0BRAd0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 19:33:26 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60274
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756663Ab0BRAdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 19:33:25 -0500
Date: Wed, 17 Feb 2010 16:33:38 -0800 (PST)
Message-Id: <20100217.163338.54972301.davem@davemloft.net>
To: apetlund@simula.no
Cc: netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi, eric.dumazet@gmail.com,
       hannemann@nets.rwth-aachen.de, linux-kernel@vger.kernel.org,
       shemminger@vyatta.com, william.allen.simpson@gmail.com,
       damian@tvk.rwth-aachen.de, ebiederm@xmission.com
Subject: Re: [net-next PATCH v4 3/3] net: TCP thin dupack
From: David Miller <davem@davemloft.net>
In-Reply-To: <4B7AAE6E.7080600@simula.no>
References: <4B7AAE6E.7080600@simula.no>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Petlund <apetlund@simula.no>
Date: Tue, 16 Feb 2010 15:40:46 +0100

> Major changes:
>       -Renamed variables, ioctl and sysctl.
>       -Added sysctl documentation.
>       -Removed redundant allocation
> 
> Signed-off-by: Andreas Petlund <apetlund@simula.no>

Patches #2 and #3 look the same, what's going on here?

Thanks.
