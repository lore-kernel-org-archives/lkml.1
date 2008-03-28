Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798AbYC1Ajy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798AbYC1Ajy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 20:39:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752536AbYC1Ajo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 20:39:44 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39580
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752225AbYC1Ajn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 20:39:43 -0400
Date: Thu, 27 Mar 2008 17:39:43 -0700 (PDT)
Message-Id: <20080327.173943.232327282.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6.26] Remove three unused method declarations in
 include/net/ipv6.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0803270205n4a15a884kaa45852e510b27c6@mail.gmail.com>
References: <eb3ff54b0803270205n4a15a884kaa45852e510b27c6@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Thu, 27 Mar 2008 11:05:55 +0200

> This patch removes three unused method declarations in include/net/ipv6.h:
> inet_getfrag_t(), ipv6_build_nfrag_opts() and ipv6_build_frag_opts().
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied, thanks.
