Return-Path: <linux-kernel-owner+w=401wt.eu-S1756540AbYDTWnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756540AbYDTWnU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 18:43:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753335AbYDTWnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 18:43:11 -0400
Received: from smtpgpe.resot.net ([217.175.160.71]:55440 "EHLO smtpgpe.ool.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbYDTWnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 18:43:09 -0400
X-Greylist: delayed 394 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Apr 2008 18:43:08 EDT
From: "werner" <werner@copaya.yi.org>
Subject: EDD problem -- regression -- crash on booting by probing EDD
To: linux-kernel@vger.kernel.org
X-Originating-IP: 217.175.173.64
X-Mailer: Usermin 1.340
Message-Id: <1208730812.6879@copaya.yi.org>
Date: Sun, 20 Apr 2008 19:33:32 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1208730812"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1208730812
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

There is a regression in 2.6.25.   Booting stops with: Probing EDD (edd=off to disable) message.

It dont work the kernel boot parameter edd=off .  With pci=off the computer continues to boot, but later it dont find hard disks etc.

Thats happening on 2.6.25   definitive, but was verified to go back until 2.6.24-rc6-git8, but it wasnt yet at 2.6.24-rc6-git2 which worked correctly.


Werner Landgraf

SYS Linux

http://linux.softpedia.com/get/System/Operating-Systems/Linux-Distributions/SYS-34168.shtml

--bound1208730812--

