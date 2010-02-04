Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758542Ab0BDWdH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 17:33:07 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60461
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758422Ab0BDWdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 17:33:05 -0500
Date: Thu, 04 Feb 2010 14:33:17 -0800 (PST)
Message-Id: <20100204.143317.133193015.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, ciprian.craciun@gmail.com
Subject: Re: [PATCH] Net / pktgen: Fix freezing problem
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100204141239.aa94e75c.akpm@linux-foundation.org>
References: <201002042250.58944.rjw@sisk.pl>
	<20100204141239.aa94e75c.akpm@linux-foundation.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 4 Feb 2010 14:12:39 -0800

> Also needed in -stable, IMO.

I'll queue it up, thanks.
