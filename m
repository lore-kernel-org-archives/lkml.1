Return-Path: <linux-kernel-owner+w=401wt.eu-S932548AbZHUUNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548AbZHUUNK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932482AbZHUUNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:13:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39327
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932359AbZHUUNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:13:06 -0400
Date: Fri, 21 Aug 2009 13:13:18 -0700 (PDT)
Message-Id: <20090821.131318.130589385.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-08-21
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090821170324.GC8532@tuxdriver.com>
References: <20090821170324.GC8532@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Fri, 21 Aug 2009 13:03:25 -0400

> One more straggler for 2.6.31...without this rtl8187b devices simply
> don't work. :-(
> 
> The patch is small and isolated to rtl8187.  I think we should take
> it for 2.6.31.
> 
> Please let me know if there are problems!

Pulled, and I'll push out to kernel.org after a test build.

Thanks!
