Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXGNPoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXGNPoT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 11:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751015AbXGNPoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 11:44:08 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33854 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXGNPoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 11:44:07 -0400
Date: Sat, 14 Jul 2007 08:37:54 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: bfields@citi.umich.edu, Trond.Myklebust@netapp.com
Subject: new 2.6.22-git5 warnings
Message-Id: <20070714083754.2c3f1d0a.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



net/sunrpc/auth_gss/auth_gss.c:1002: warning: implicit declaration of function 'lock_kernel'
net/sunrpc/auth_gss/auth_gss.c:1004: warning: implicit declaration of function 'unlock_kernel'


allmodconfig or allyesconfig on x86_64.

---
~Randy
/me goes hiking.
