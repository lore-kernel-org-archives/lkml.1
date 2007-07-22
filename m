Return-Path: <linux-kernel-owner+w=401wt.eu-S1760429AbXGVO2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760429AbXGVO2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 10:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753628AbXGVO2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 10:28:35 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:44477 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753443AbXGVO2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 10:28:33 -0400
From: Markus <lists4me@web.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: konqueror suddenly vanishing, "konqueror: Fatal IO error: client killed"
Date: Sun, 22 Jul 2007 16:26:10 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>, kfm-devel@mail.kde.org
References: <20070706173319.GA2356@elte.hu> <200707210026.19977.lists4me@web.de> <20070722115917.GA28939@elte.hu>
In-Reply-To: <20070722115917.GA28939@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707221626.11919.lists4me@web.de>
X-Provags-ID: V01U2FsdGVkX182GmjTEoskn0DxyFD309UqJwhPmsANZOpvDeqx
	gk2j47GNRWJQ5fl4M2td08L1KcS4HN5SbgRxk+Tq3sOnf45Dl4
	+brbqwUUM=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> it _seems_ to be related to KDE apps most of the time, right?
You are right (although some gtk-apps have the same problem), but that 
may be caused by the fact that I dont _see_ other apps vanish... I'll 
try some console-based apps...

> Could you perhaps mention the kde and Xorg versions you are using?
I have konqueror 3.5.5 and Xorg 7.2 on a native amd64 system (gcc 4.1.2 
and glibc 2.5).


   Markus
