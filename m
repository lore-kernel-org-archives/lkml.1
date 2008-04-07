Return-Path: <linux-kernel-owner+w=401wt.eu-S1756075AbYDGVDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756075AbYDGVDr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 17:03:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751990AbYDGVDl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 17:03:41 -0400
Received: from indigo.cs.bgu.ac.il ([132.72.42.23]:48104 "EHLO
	indigo.cs.bgu.ac.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896AbYDGVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 17:03:40 -0400
X-Greylist: delayed 1182 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Apr 2008 17:03:40 EDT
Date: Mon, 7 Apr 2008 23:45:15 +0300 (IDT)
Message-Id: <200804072045.m37KjFEX016950@indigo.cs.bgu.ac.il>
From: "eial@cs.bgu.ac.il" <eial@cs.bgu.ac.il>
To: linux-kernel@vger.kernel.org
Subject: keyboard disconnects with kernel 2.6.24-r4
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Organization: CS Department
X-Mailer: CS Webmail v3.10
X-Priority: 3 (Normal)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


hello, I own a DV9000z, running gentoo and kernel 2.6.24-r3 on it, I'm not using r4 because while working with the computer, after a while, my keyboard disconnects. trying to shutdown the computer causes in system freeze.
this do not happens in r3, the difference that I saw between r3 and r4 is that in r3 my inputs are labeled /class/input/input4 while in r4 they are labeled /devices/platform/i8042/serio0/input/input4.
how can I fix it?

thanks.


