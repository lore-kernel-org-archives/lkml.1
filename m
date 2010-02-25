Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0BYIqT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 03:46:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:51237
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752916Ab0BYIqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 03:46:18 -0500
Date: Thu, 25 Feb 2010 00:46:36 -0800 (PST)
Message-Id: <20100225.004636.49827727.davem@davemloft.net>
To: yanmin_zhang@linux.intel.com
Cc: mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: Check the right return variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1267066851.1726.9.camel@localhost>
References: <1267066851.1726.9.camel@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Date: Thu, 25 Feb 2010 11:00:51 +0800

> In function dso__split_kallsyms, curr_map saves the return value of
> map__new2. So check it instead of var map after the calling returns.
> 
> Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>

Acked-by: David S. Miller <davem@davemloft.net>
