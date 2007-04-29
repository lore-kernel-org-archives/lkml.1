Return-Path: <linux-kernel-owner+w=401wt.eu-S933223AbXD2NA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933223AbXD2NA2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:00:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933224AbXD2NA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:00:27 -0400
Received: from ihemail3.lucent.com ([135.245.0.37]:36663 "EHLO
	ihemail3.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933223AbXD2NAQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:00:16 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-MimeOLE: Produced By Microsoft Exchange V6.0.6249.0
Subject: problem that /bin/sh keeps spawning
Date: Sun, 29 Apr 2007 20:59:36 +0800
Message-ID: <2AC135F730C4A045BAE4F1C1CB83FD4B03EF70C9@exch03.qd.lucent.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] CFS scheduler, -v6
Thread-Index: AceKXacZVAr8JbJwQpyl40q9KYuCCAAABewQ
From: "Shan, Guo Wen (Gavin)" <gshan@alcatel-lucent.com>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Apr 2007 12:59:36.0153 (UTC) FILETIME=[3D310490:01C78A5E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm using busybox1.5. The /bin/sh keeps spawning as following output shows. Thanks for suggestions.

Freeing unused kernel memory: 1536k init
Warning: unable to open an initial console.

Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 191, tty '/dev/ttyS1': '/bin/sh'
# 
Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 192, tty '/dev/ttyS1': '/bin/sh'
# 
Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 193, tty '/dev/ttyS1': '/bin/sh'
# 
Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 194, tty '/dev/ttyS1': '/bin/sh'
# 
Please press Enter to activate this console. init: can't log to /dev/tty5
starting pid 195, tty '/dev/ttyS1': '/bin/sh'
# 
:
:
<Similar Output as the above>
:
:

Gavin
