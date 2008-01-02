Return-Path: <linux-kernel-owner+w=401wt.eu-S1760315AbYACBLR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315AbYACBLR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 20:11:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbYACBLF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 20:11:05 -0500
Received: from ns1.fjaunet.com.br ([200.230.87.129]:52088 "EHLO
	mail.fjaunet.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755080AbYACBLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 20:11:04 -0500
X-Greylist: delayed 1515 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jan 2008 20:11:04 EST
Date: Wed, 2 Jan 2008 22:23:34 -0000
From: "Rodrigo Rubira Branco (BSDaemon)" <rodrigo@kernelhacking.com>
To: tech-kern@netbsd.org, "linux-kernel@vger.kernel.org"@fjaunet.com.br,
       "linux-mm@kvack.org"@fjaunet.com.br
Reply-to: "Rodrigo Rubira Branco (BSDaemon)" <rodrigo@kernelhacking.com>
Subject: [ANNOUNCE] ebizzy 0.3 released
X-Priority: 3
X-Mailer: UebiMiau 2.7.2
X-Original-IP: 189.33.216.170
Content-Transfer-Encoding: 7BIT
X-MSMail-Priority: Medium
Importance: Medium
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Message-Id: <20080103002334.58FC78BD86@mail.fjaunet.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebizzy is designed to generate a workload resembling common web application
server workloads.  It is especially useful for testing
changes to memory management, and whenever a highly threaded application
with a large working set and many vmas is needed.

This is release 0.3 of ebizzy.  It reports a rate of transactions per
second, compiles on Linux/Solaris/FreeBSD/HPUX, and scales better.

Available for download at:

http://ebizzy.sf.net



Rodrigo (BSDaemon).

--
http://www.kernelhacking.com/rodrigo

Kernel Hacking: If i really know, i can hack

GPG KeyID: 1FCEDEA1



________________________________________________
Message sent using UebiMiau 2.7.2

