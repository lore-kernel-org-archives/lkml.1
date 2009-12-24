Return-Path: <linux-kernel-owner+w=401wt.eu-S1753142AbZLXEwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbZLXEwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 23:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbZLXEwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 23:52:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40556
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751032AbZLXEwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 23:52:41 -0500
Date: Wed, 23 Dec 2009 20:52:41 -0800 (PST)
Message-Id: <20091223.205241.70185990.davem@davemloft.net>
To: johnstul@us.ibm.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [RFC][PATCH 14/14] Convert sparc to
 read/update_persistent_clock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1261541771.3508.76.camel@localhost.localdomain>
References: <1261541643.3508.74.camel@localhost.localdomain>
	<1261541703.3508.75.camel@localhost.localdomain>
	<1261541771.3508.76.camel@localhost.localdomain>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: john stultz <johnstul@us.ibm.com>
Date: Tue, 22 Dec 2009 20:16:11 -0800

> This patch converts the sparc architecture to use the generic
> read_persistent_clock and update_persistent_clock interfaces, reducing
> the amount of arch specific code we have to maintain, and allowing for
> further cleanups in the future.
> 
> I have not built or tested this patch, so help from arch maintainers
> would be appreciated.
> 
> Signed-off-by: John Stultz <johnstul@us.ibm.com>

This looks fine to me:

Acked-by: David S. Miller <davem@davemloft.net>
