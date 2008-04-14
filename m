Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbYDNPpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbYDNPpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755946AbYDNPp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:45:27 -0400
Received: from [198.99.130.12] ([198.99.130.12]:48339 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYDNPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:45:26 -0400
Date: Mon, 14 Apr 2008 11:44:58 -0400
From: Jeff Dike <jdike@addtoit.com>
To: WANG Cong <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [Patch] UML: Clean up arch/um/drivers/ubd_kern.c
Message-ID: <20080414154458.GB9434@c2.user-mode-linux.org>
References: <20080413.005559.143852921.xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080413.005559.143852921.xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are all fine, except for the mconsole one for which I need some more
explanation.

				Jeff

-- 
Work email - jdike at linux dot intel dot com
