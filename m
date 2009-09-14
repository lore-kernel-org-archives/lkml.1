Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbZINNm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbZINNm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 09:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbZINNm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 09:42:57 -0400
Received: from imp02.mtu.ru ([62.5.255.19]:59934 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750749AbZINNm4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 09:42:56 -0400
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
Organization: Pavlinux Inc.
To: linux-kernel@vger.kernel.org
Subject: INGO Why you remove  set_user_nice() from kernel/kthread.c
Date: Mon, 14 Sep 2009 17:42:44 +0400
User-Agent: KMail/1.9.10
X-Face: =?utf-8?q?=2EqZWJ=3F=248Zrl=26r=7C-=3B8=7ESTufc!R0d=5E=3FdE-g/S=5FryU2S=5D=27?=
 =?utf-8?q?=24vQ7EYY=3DBSj=5DJ-Gp=5FVXPpl=27ci/i=0A=09yH=5B=249HGUU=3Af?=@6hyHiQKeEv#S(K4XtVe$?0UO@',
 =?utf-8?q?!=25=5CR=3A7a=3BITA=3B=7Cs=7C=3F=25+T6=7E5=3Aq=2E2i=5DzA=25=0A=09?=
 =?utf-8?q?Mn-t3kOWGQ?=(7@ZOZ/0@+baHY#Fj&e/k'#p}#F<U{[DP[@"XbG&pmU~{oOMsPc4q|4/,
 =?utf-8?q?du8=0A=09?="'s*i`2=h[f!7!`#',39O3
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200909141742.45487.pavel@pavlinux.ru>
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Next patсh -  
http://www.kernel.org/diff/diffview.cgi?file=%2Fpub%2Flinux%2Fkernel%2F%2Fv2.6%2Fsnapshots%2Fpatch-2.6.31-git2.bz2;z=548

This patch defines the core processes that are working with nice leve equal to 
zero , as in the BFS. :)

Why?

VirtualBox, Vmware, QEMU, Firefox, Azureus, and many subsystems and 
applications began working with large timeouts. In appearance similar to 
hang.

