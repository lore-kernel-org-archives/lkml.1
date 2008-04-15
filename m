Return-Path: <linux-kernel-owner+w=401wt.eu-S1763497AbYDOHao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763497AbYDOHao (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761423AbYDOHaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:30:24 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41577
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754824AbYDOHaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:30:23 -0400
Date: Tue, 15 Apr 2008 00:30:24 -0700 (PDT)
Message-Id: <20080415.003024.115517023.davem@davemloft.net>
To: bunk@kernel.org
Cc: kkeil@suse.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org, rpjday@crashcourse.ca
Subject: Re: [2.6 patch] include/linux/isdn.h: remove dead code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080414184058.GJ6695@cs181133002.pp.htv.fi>
References: <20080414184058.GJ6695@cs181133002.pp.htv.fi>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>
Date: Mon, 14 Apr 2008 21:40:58 +0300

> This patch remove the usage of a nonexisting kconfig variable.
> 
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied.
