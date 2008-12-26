Return-Path: <linux-kernel-owner+w=401wt.eu-S1754087AbYLZVxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbYLZVxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 16:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbYLZVxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 16:53:45 -0500
Received: from bu3sch.de ([62.75.166.246]:36782 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbYLZVxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 16:53:45 -0500
From: Michael Buesch <mb@bu3sch.de>
To: Bart De Schuymer <bdschuym@pandora.be>,
       Harald Welte <laforge@netfilter.org>
Subject: ebt_ulog out of memory.
Date: Fri, 26 Dec 2008 22:52:45 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200812262252.45560.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I get the following error message at bootup.
[    1.839948] ebt_ulog: out of memory trying to call netlink_kernel_create

The system certainly is not out of memory, because it works fine, otherwise.

The kernel is a 2.6.28-rc9 on an x86_64 architecture.

-- 
Greetings, Michael.
