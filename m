Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbXBRVkb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbXBRVkb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 16:40:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbXBRVkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 16:40:31 -0500
Received: from mail.screens.ru ([213.234.233.54]:56818 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752174AbXBRVk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 16:40:28 -0500
Date: Mon, 19 Feb 2007 00:39:59 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jarek Poplawski <jarkao2@o2.pl>, "David S. Miller" <davem@davemloft.net>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Jun Nakajima <jun.nakajima@intel.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       David Howells <dhowells@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] don't use _WORK_NAR
Message-ID: <20070218213959.GA4202@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches change the code which I absolutely don't understand.
Compile tested. Please review.

Oleg.

