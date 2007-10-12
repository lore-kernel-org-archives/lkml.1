Return-Path: <linux-kernel-owner+w=401wt.eu-S1757895AbXJLEtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895AbXJLEtS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 00:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753385AbXJLEtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 00:49:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:49107 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752010AbXJLEtB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 00:49:01 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+FgUVgFiyFzRr8o97pPOHwZezJ8BjKltYxM6eR0R
	BKI00bDbAA8JUn
Subject: 2.6.23.git build error
From: Mike Galbraith <efault@gmx.de>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 12 Oct 2007 06:48:58 +0200
Message-Id: <1192164538.10413.3.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

Freshly pulled 2.6.23.git failed to build:

make[1]: *** No rule to make target `arch/x86/kernel/asm-offsets.c', needed by `arch/x86/kernel/asm-offsets.s'.  Stop.
make: *** [prepare0] Error 2
make: *** Waiting for unfinished jobs....

	-Mike

