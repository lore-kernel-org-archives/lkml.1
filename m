Return-Path: <linux-kernel-owner+w=401wt.eu-S1756770AbZGMSLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756770AbZGMSLz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755835AbZGMSLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:11:54 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56225
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755764AbZGMSLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:11:53 -0400
Date: Mon, 13 Jul 2009 11:11:57 -0700 (PDT)
Message-Id: <20090713.111157.59101216.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: giamteckchoon@gmail.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: linux-2.6.30.1 with gcc-3.4.6 compile error
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A5B6F12.6030101@gmail.com>
References: <9b5c9bb30907130944l3624870ck507f5a9f0f79452b@mail.gmail.com>
	<4A5B6F12.6030101@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 13 Jul 2009 19:29:54 +0200

> [PATCH] igb: gcc-3.4.6 fix
> 
> forward declaration of inline function should be avoided, or
> old gcc cannot compile.
> 
> Reported-by: Teck Choon Giam <giamteckchoon@gmail.com>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks a lot Eric.
