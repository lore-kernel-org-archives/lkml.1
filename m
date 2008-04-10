Return-Path: <linux-kernel-owner+w=401wt.eu-S1756672AbYDJJBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbYDJJBl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 05:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYDJJBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 05:01:31 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45080
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752480AbYDJJBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:01:30 -0400
Date: Thu, 10 Apr 2008 02:01:31 -0700 (PDT)
Message-Id: <20080410.020131.264375762.davem@davemloft.net>
To: ramirose@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-2.6.26] [IPV6] Remove three method declarations in
 include/net/ndisc.h.
From: David Miller <davem@davemloft.net>
In-Reply-To: <eb3ff54b0804010433v67f0ea60w4681b3a3400c3484@mail.gmail.com>
References: <eb3ff54b0804010433v67f0ea60w4681b3a3400c3484@mail.gmail.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Rami Rosen" <ramirose@gmail.com>
Date: Tue, 1 Apr 2008 14:33:54 +0300

> Hi,
> This patch removes two unused method declarations in include/net/ndisc.h:
> ndisc_forwarding_on(void) and  ndisc_forwarding_off(void);
> Also igmp6_cleanup(void) appears twice in this header, so one
> igmp6_cleanup(void)
> declaration is removed.
> 
> Signed-off-by: Rami Rosen <ramirose@gmail.com>

Applied to net-2.6.26, thanks.
