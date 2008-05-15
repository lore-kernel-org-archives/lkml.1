Return-Path: <linux-kernel-owner+w=401wt.eu-S1764126AbYEOUa4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764126AbYEOUa4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 16:30:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754260AbYEOUas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 16:30:48 -0400
Received: from aun.it.uu.se ([130.238.12.36]:49612 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbYEOUar (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 16:30:47 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18476.40303.232402.312481@harpo.it.uu.se>
Date: Thu, 15 May 2008 22:30:39 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.26-rc1 lost half the RAM on UltraSPARC 5
In-Reply-To: <18476.33854.71781.133881@harpo.it.uu.se>
References: <20080512.153628.193699676.davem@davemloft.net>
	<20080512.153948.193688062.davem@davemloft.net>
	<18473.60551.911448.98269@alkaid.it.uu.se>
	<20080514.231111.107604885.davem@davemloft.net>
	<18476.33854.71781.133881@harpo.it.uu.se>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson writes:
 > Thanks Dave. As the dmesg diff below shows, this patch fixed
 > my lost RAM issue. I actually have about 8KB more available

Doh! s/KB/MB/ of course.

 > now than I had with 2.6.25.
