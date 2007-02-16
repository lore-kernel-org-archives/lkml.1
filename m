Return-Path: <linux-kernel-owner+w=401wt.eu-S1751203AbXBPL5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbXBPL5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 06:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbXBPL5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 06:57:44 -0500
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:44101 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203AbXBPL5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 06:57:44 -0500
Message-ID: <45D59C3C.4090403@drzeus.cx>
Date: Fri, 16 Feb 2007 12:57:48 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
User-Agent: Thunderbird 1.5.0.9 (X11/20070131)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Block layer still stack abuser?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was wondering if the block layer has been changed into a more serialized
manner yet? I've been trying to google this, but so far no luck. I know there
was some talk about removing the stack based approach, but I can't find any
information about where this went.

If it is currently fixed, a pointer to from which version would be nice.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
