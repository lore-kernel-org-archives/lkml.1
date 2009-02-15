Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbZBOVrz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbZBOVrz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 16:47:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbZBOVrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 16:47:31 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:48279 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536AbZBOVr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 16:47:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Len Brown <lenb@kernel.org>
Subject: [PATCH 0/2] PM: x86-64 suspend-resume fix
Date: Sun, 15 Feb 2009 22:44:46 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc5-tst; KDE/4.2.0; x86_64; ; )
Cc: Jiri Slaby <jirislaby@gmail.com>, Cyrill Gorcunov <gorcunov@openvz.org>,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902152244.47326.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches clean-up and fix the x86-64 resume code.

1/2 is a cleanup, but it is simple enough to be applied now IMO.

2/2 is a bug fix based on 1/2, which is 2.6.29 material.

Please apply them to the suspend branch and push to Linus for 2.6.29 (Ingo
says he doesn't mind if they go through your tree).

Thanks,
Rafael

