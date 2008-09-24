Return-Path: <linux-kernel-owner+w=401wt.eu-S1753223AbYIXJVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbYIXJVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 05:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbYIXJVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 05:21:37 -0400
Received: from mail.transmode.se ([83.241.175.147]:26979 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbYIXJVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 05:21:36 -0400
Subject: UIO device name
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: hjk@linutronix.de, gregkh@suse.de
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Wed, 24 Sep 2008 11:21:33 +0200
Message-Id: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As far as I can see there isn't a way to name the /dev/uio%d device file
to something more useful, is that so?
I would like to name the device file from within the kernel so I can
find the correct device from userspace.
The very least is to control the minor(%d) number.

 Jocke
