Return-Path: <linux-kernel-owner+w=401wt.eu-S1763608AbYBMAOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763608AbYBMAOv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:14:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbYBMAOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:14:42 -0500
Received: from simmts5.bellnexxia.net ([206.47.199.163]:33975 "EHLO
	simmts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757688AbYBMAOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:14:41 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgAAAFTFsUecIprE/2dsb2JhbAAIihGjMg
Message-ID: <47B2366C.4020901@gmail.com>
Date: Tue, 12 Feb 2008 20:14:36 -0400
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071229)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: git-x86 mm branch compile error
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  CC      arch/x86/mm/pageattr.o
arch/x86/mm/pageattr.c: In function ‘change_page_attr_set_clr’:
arch/x86/mm/pageattr.c:778: error: incompatible type for argument 1 of
‘cpa_check_alias’
make[1]: *** [arch/x86/mm/pageattr.o] Error 1
make: *** [arch/x86/mm] Error 2

at tip 5248bbad9c72dd576aa8f3b44b5a959a7cae6ce1 x86: make
DEBUG_PAGEALLOC & HIBERNATE work

