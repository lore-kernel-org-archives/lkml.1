Return-Path: <linux-kernel-owner+w=401wt.eu-S1751433AbZGWKIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbZGWKIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 06:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751119AbZGWKIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 06:08:48 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:41286 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZGWKIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 06:08:48 -0400
Date: Thu, 23 Jul 2009 06:06:18 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: annoying drivers/char/vr41xx_giu.c file still there
Message-ID: <alpine.LFD.2.00.0907230604180.3789@localhost>
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


  i thought someone was going to clean up this occasional git glitch:

$ git diff
diff --git a/drivers/char/vr41xx_giu.c b/drivers/char/vr41xx_giu.c
deleted file mode 100644
index e69de29..0000000
$

  that same diff output still pops up on occasion.  if you do a hard
reset back to origin, it goes away but it will eventually reappear.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
"Kernel Newbie Corner" column @ linux.com:          http://cli.gs/WG6WYX
========================================================================
