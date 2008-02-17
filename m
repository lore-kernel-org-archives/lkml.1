Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYBQBk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYBQBk1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 20:40:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753299AbYBQBkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 20:40:15 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:36665 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285AbYBQBkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 20:40:14 -0500
Subject: [RT] 2.6.24 - stuck in serial8250_console_write
From: Jon Masters <jonathan@jonmasters.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Sat, 16 Feb 2008 20:39:39 -0500
Message-Id: <1203212379.5672.9.camel@perihelion>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yo,

Anyone seen a 2.6.24 system deadlock unable to printk because another
task is already holding the console lock?

Jon.


