Return-Path: <linux-kernel-owner+w=401wt.eu-S1755731AbYGIWLD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755731AbYGIWLD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 18:11:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYGIWKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 18:10:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35455
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750864AbYGIWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 18:10:49 -0400
Date: Wed, 09 Jul 2008 15:10:49 -0700 (PDT)
Message-Id: <20080709.151049.240584078.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-07-09
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080709204202.GA17820@tuxdriver.com>
References: <20080709204202.GA17820@tuxdriver.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Wed, 9 Jul 2008 16:42:02 -0400

> A few more fixes for 2.6.26...the only big parts are either moving
> existing code or adding missing initializations to zero.

Pulled into net-2.6

I'll push back out to kernel.org after some build tests.

Thanks!
