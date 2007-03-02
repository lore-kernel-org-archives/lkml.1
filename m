Return-Path: <linux-kernel-owner+w=401wt.eu-S964792AbXCBJYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792AbXCBJYG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 04:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933303AbXCBJYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 04:24:06 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:55390 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933295AbXCBJYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 04:24:05 -0500
Date: Fri, 02 Mar 2007 10:23:51 +0100 (CET)
Message-Id: <20070302.102351.146595518.wl@gnu.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>
Subject: Memory stick reader Ricoh R5C592 supported?
From: Werner LEMBERG <wl@gnu.org>
X-Mailer: Mew version 5.1.50 on Emacs 22.0.95.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Provags-ID: kundenserver.de abuse@kundenserver.de login:2dc398bc694a1e60948148ba0a42c0da
X-Provags-ID2: V01U2FsdGVkX1+2aEd1rAX67WDwZ0FHA02cNLMS+mTf0LUjoJ4
 4il0hXLJVG4HJ6Akg5H4e30FcxnO0rOhf5K7KqBaJihD+ap+Tx
 ylT8WSujNyzD3PYy5+AIQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Folks,


my Dell Inspiron 6400 laptop has both a Ricoh R5C822 host adapter (for
SD, MMC, etc.) and a Ricoh R5C592 host adapter for memory sticks.

While the former works just fine, it seems to me that the latter
hasn't any support.  Indeed, inserting a Sony MSA-128A memory stick
causes no reaction whatsoever.  Searching with google, I haven't found
anything related to this chip; looking into the kernel source code
wasn't successful either.

Can you please shed some light on the current situation?  I'm using
kernel 2.6.20.


    Werner
