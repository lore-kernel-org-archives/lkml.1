Return-Path: <linux-kernel-owner+w=401wt.eu-S1753406AbZI1Vvc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406AbZI1Vvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 17:51:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752693AbZI1Vvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 17:51:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59086
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbZI1Vvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 17:51:31 -0400
Date: Mon, 28 Sep 2009 14:51:50 -0700 (PDT)
Message-Id: <20090928.145150.94640612.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-09-28
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090928214047.GF4737@tuxdriver.com>
References: <20090928214047.GF4737@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Mon, 28 Sep 2009 17:40:48 -0400

> There are number of small fixes to core wireless infrastructure from
> Johannes Berg.  These have been bounced around on the list quite a bit
> during the last several days, so I think they are solid.  Also included
> is one that improves some debugging messages. 
> 
> There are a few fixes for the iwlwifi family of drivers, including a
> buffer overrun, a memory leak, and another debugging message fix.
> 
> Arjan showed-up with a bounds checking fix in some ancient wext code.  I
> included it due to the potential security implications.
> 
> The sony-laptop fixes may seem a bit out of place, but they are related
> to rfkill.  Also, they are "Acked-by: Mattia Dongili <malattia@linux.it>",
> who is the listed maintainer for that code.  I put them at the end, so
> if you want you can pull from 8f1546cadf7ac5e9a40d54089a1c7302264ec49b
> instead of master.
> 
> Please let me know if there are problems!

Pulled, thanks a lot John!
