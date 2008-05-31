Return-Path: <linux-kernel-owner+w=401wt.eu-S1754498AbYEaNap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbYEaNap (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 09:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYEaNaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 09:30:08 -0400
Received: from mx1.riseup.net ([204.13.164.18]:44775 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYEaNaG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 09:30:06 -0400
Message-Id: <20080531132808.644758754@kaehlcke.net>
User-Agent: quilt/0.46-1
Date: Sat, 31 May 2008 15:28:08 +0200
From: matthias@kaehlcke.net
To: dwmw2@infradead.org, linux-mtd@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch 0/2] MTD: use list_for_each_entry()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MTD: Use list_for_each_entry() instead of list_for_each() in add_mtd_device() and del_mtd_device()

-- 
Matthias Kaehlcke
Embedded Linux Engineer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
