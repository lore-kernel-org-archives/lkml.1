Return-Path: <linux-kernel-owner+w=401wt.eu-S1755766AbXISXC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766AbXISXC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 19:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbXISXCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 19:02:38 -0400
Received: from sccrmhc14.comcast.net ([204.127.200.84]:64599 "EHLO
	sccrmhc14.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840AbXISXCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 19:02:37 -0400
Subject: Mask Issue?
From: Chris Holvenstot <cholvenstot@comcast.net>
To: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 19 Sep 2007 17:57:56 -0500
Message-Id: <1190242676.16474.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Still being a little new at this I am not sure if this is an issue at
all or not but I noted that while building the 2.6.23-rc6-git8 kernel
this afternoon I received the following error message: 

Building modules, stage 2.
  MODPOST 1670 modules
WARNING: Can't handle masks in drivers/mtd/nand/cafe_nand:FFFF0

I have been building each of the kernels in the 2.6.23-rc series and had
not noted this message before.  I apologize if this is a non-issue.

