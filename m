Return-Path: <linux-kernel-owner+w=401wt.eu-S1753964AbYIXFW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbYIXFW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 01:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbYIXFWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 01:22:19 -0400
Received: from 166-70-238-42.ip.xmission.com ([166.70.238.42]:49854 "EHLO
	ns1.wolfmountaingroup.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYIXFWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 01:22:18 -0400
Message-ID: <54829.166.70.238.43.1222231677.squirrel@webmail.wolfmountaingroup.com>
Date: Tue, 23 Sep 2008 22:47:57 -0600 (MDT)
Subject: [ANNOUNCE] mdb: Merkey's Linux Kernel Debugger 2.6.27-rc7-2        
                       (09/23/08)
From: jmerkey@wolfmountaingroup.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ChangeLog, 09/24/2008

* Fix compile problems with AMD series processors reported 9/23/08.

* Fix problems with genapic declarations in reboot.c (SMP case) when
supporting AMD ELAN processors

* Added AMD and AMD64 configurations to debugger test harness.

Thanks to the person who found these problems on AMD ELAN series
processors and for performing testing on AMD systems for me.



TO-DO

X86_64 test harness completed.
x86_64 support completed.  Testing in process.
IA64 system received early (mid-September) from HP, in process.


MDB repositories

http://sourceforge.net/projects/merkeydebugger
http://code.google.com/p/merkeydebugger
http://www.wolfmountaingroup.org


current mdb-2.6.27-rc7 patches
ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc7-ia32-09-23-08.patch

Jeffrey Vernon Merkey
Wolf Mountain Group, Inc.












