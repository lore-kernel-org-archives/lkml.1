Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZGEQJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZGEQJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 12:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZGEQJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 12:09:23 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:54512 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995AbZGEQJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 12:09:22 -0400
Date: Sun, 5 Jul 2009 12:07:14 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: what's with the git status of drivers/char/vr41xx_giu.c?
Message-ID: <alpine.LFD.2.00.0907051205420.16532@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  a couple times this morning already, git diff has shown:

diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
deleted file mode 100644
index e69de29..0000000

but i'm not touching that file.  and even after doing a pull and
reset, that message eventually came back.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
