Return-Path: <linux-kernel-owner+w=401wt.eu-S965116AbXCAOeK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965116AbXCAOeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2007 09:34:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965115AbXCAOeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Mar 2007 09:34:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:45326 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S965122AbXCAOeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2007 09:34:09 -0500
Cc: akpm@linux-foundation.org, linux-dvb@linuxtv.org, domi.dumont@free.fr,
       Jiri Slaby <jirislaby@gmail.com>, bunk@stusta.de,
       linux-kernel@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>,
       venkatesh.pallipadi@intel.com
Content-Type: text/plain; charset="us-ascii"
Date: Thu, 01 Mar 2007 15:34:07 +0100
From: "Uwe Bugla" <uwe.bugla@gmx.de>
Message-ID: <20070301143407.29950@gmx.net>
MIME-Version: 1.0
Subject: 2.6.21-rc1-git2 is incompilable
To: torvalds@linux-foundation.org
X-Authenticated: #8359428
X-Flags: 0001
X-Mailer: WWW-Mail 6100 (Global Message Exchange)
X-Priority: 3
X-Provags-ID: V01U2FsdGVkX19cOexVCmNcpWY9EJJt9mFcGzPtp7WLG9FU3p3q95
 tViZo3wYhufp1R8HNiEkSpAC4= 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,
trying to compile kernel 2.6.21-rc1-git2 is impossible. The broken module where the compiler gives up is /arch/i386/kernel/io_apic.c.

Regards

Uwe

P. S.: Wouldn't it be a good idea to test at least error-free compilation before stuff like this is being published?

-- 
"Feel free" - 10 GB Mailbox, 100 FreeSMS/Monat ...
Jetzt GMX TopMail testen: www.gmx.net/de/go/mailfooter/topmail-out
