Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbZJIJQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbZJIJQb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 05:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759920AbZJIJQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 05:16:30 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48153
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757692AbZJIJQ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 05:16:29 -0400
Date: Fri, 09 Oct 2009 02:16:24 -0700 (PDT)
Message-Id: <20091009.021624.93363649.davem@davemloft.net>
To: akinobu.mita@gmail.com
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       sparclinux@vger.kernel.org
Subject: Re: [PATCH 6/8] sparc: Use bitmap_find_next_zero_area
From: David Miller <davem@davemloft.net>
In-Reply-To: <1255076961-21325-6-git-send-email-akinobu.mita@gmail.com>
References: <1255076961-21325-4-git-send-email-akinobu.mita@gmail.com>
	<1255076961-21325-5-git-send-email-akinobu.mita@gmail.com>
	<1255076961-21325-6-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Fri,  9 Oct 2009 17:29:19 +0900

> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: sparclinux@vger.kernel.org
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
