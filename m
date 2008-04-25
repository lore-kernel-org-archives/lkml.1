Return-Path: <linux-kernel-owner+w=401wt.eu-S1763289AbYDYPys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763289AbYDYPys (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 11:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759902AbYDYPyk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 11:54:40 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:41682 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756889AbYDYPyk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 11:54:40 -0400
Date: Fri, 25 Apr 2008 17:54:23 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: LKML <linux-kernel@vger.kernel.org>
Subject: post-2.6.25 locks up hard without any message
Message-ID: <20080425175423.4bfd1c7b@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Something that was merged this window has made my life a bit difficult.
My machine (a Thinkpad R61) locks up hard after a few minutes. There is
no output on the console and no blinking keyboard leds, so it doesn't
look like it's a panic.

My current HEAD is v2.6.25-3530-g94bc891 but I saw it in
v2.6.25-2519-g3925e6f as well.

Any ideas or is it time for everyone's favourite git tool?

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
