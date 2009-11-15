Return-Path: <linux-kernel-owner+w=401wt.eu-S1751285AbZKPBIJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751285AbZKPBIJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 20:08:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbZKPBII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 20:08:08 -0500
Received: from astoria.ccjclearline.com ([64.235.106.9]:59822 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbZKPBIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 20:08:07 -0500
X-Greylist: delayed 5551 seconds by postgrey-1.27 at vger.kernel.org; Sun, 15 Nov 2009 20:08:07 EST
Date: Sun, 15 Nov 2009 03:12:59 -0500 (EST)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: curious about alleged "compatibility" bits for lm-sensors
Message-ID: <alpine.LFD.2.00.0911150310550.8158@localhost>
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


  from drivers/i2c/Kconfig:

config I2C_COMPAT
        boolean "Enable compatibility bits for old user-space"
        default y
        help
          Say Y here if you intend to run lm-sensors 3.1.1 or older, or any
          other user-space package which expects i2c adapters to be class
          devices. If you don't know, say Y.

  as i read it, lm-sensors 3.1.1 *is* the current version, as you can
read here:

  http://lm-sensors.org/wiki/Download

so how does that represent "old user-space"?  i'm just curious.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

            Linux Consulting, Training and Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Twitter:                                       http://twitter.com/rpjday
========================================================================
