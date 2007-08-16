Return-Path: <linux-kernel-owner+w=401wt.eu-S1761126AbXHPK7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761126AbXHPK7A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2007 06:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbXHPK6u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Aug 2007 06:58:50 -0400
Received: from mail.gmx.net ([213.165.64.20]:48279 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752095AbXHPK6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2007 06:58:49 -0400
X-Authenticated: #228032
X-Provags-ID: V01U2FsdGVkX185d+ByMkA5q75wZerZzcT7pU6BM3dupxA/x1DEAm
	biiKJ0Dbr6Tdd9
Date: Thu, 16 Aug 2007 12:55:26 +0200
From: Simon Peter <simon.peter@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: sysctl_tcp_keepalive_time
Message-Id: <20070816125526.9a895d09.simon.peter@gmx.de>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

is there any reason why sysctl_tcp_keepalive_time (reflected
by /proc/sys/net/ipv4/tcp_keepalive_time) is set to 7200 seconds? Is
this specified somewhere?

Thanks,
Simon
