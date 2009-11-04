Return-Path: <linux-kernel-owner+w=401wt.eu-S1756071AbZKDNHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071AbZKDNHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 08:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756057AbZKDNHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 08:07:14 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57192
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755952AbZKDNHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:07:09 -0500
Date: Wed, 04 Nov 2009 05:07:34 -0800 (PST)
Message-Id: <20091104.050734.211699606.davem@davemloft.net>
To: tfransosi@gmail.com
Cc: trivial@kernel.org, yanghy@cn.fujitsu.com, baum@tehutinetworks.net,
       andy@greyhouse.net, shemminger@vyatta.com, apkm@linux-fundation.org,
       ben@decadent.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: remove duplicated MIN macro from tehuti.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1257253829-4531-1-git-send-email-tfransosi@gmail.com>
References: <1257253829-4531-1-git-send-email-tfransosi@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thiago Farina <tfransosi@gmail.com>
Date: Tue,  3 Nov 2009 08:10:29 -0500

> Since the kernel api already has the macro "min",
> just use it instead of declaring another one.
> 
> Signed-off-by: Thiago Farina <tfransosi@gmail.com>

Applied to net-next-2.6, thanks!
