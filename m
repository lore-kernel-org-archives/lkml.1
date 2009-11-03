Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbZKCSPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbZKCSPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 13:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752276AbZKCSPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 13:15:10 -0500
Received: from qmta06.emeryville.ca.mail.comcast.net ([76.96.30.56]:41581 "EHLO
	QMTA06.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754751AbZKCSPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 13:15:09 -0500
Message-Id: <200911031815.nA3IFCe6017661@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: linux-kernel@vger.kernel.org
Subject: Can build 2.6.31.5 on one P4 but not another.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Tue, 03 Nov 2009 11:15:12 -0700
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can someone explain this to me.
I can build 2.6.31.5 on one of my Pentium 4's with no problems, 
   it boots and runs.

On a second P4, the build fails (compile works, load fails) with
comments about undefined references to:
	sleep_on_common
   and  __up

These appear in 
	sched.c
   and  semaphore.c

I dont understand how this can build on one P4 and not another.

-- 
                                        Reg.Clemens
                                        reg@dwf.com


