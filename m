Return-Path: <linux-kernel-owner+w=401wt.eu-S1752446AbZISTzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbZISTzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 15:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751714AbZISTzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 15:55:05 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:60406 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbZISTzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 15:55:04 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-kernel@vger.kernel.org
Subject: Hibernation oops with 2.6.31 won't fit the screen - how to debug?
Date: Sat, 19 Sep 2009 21:55:00 +0200
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909192155.01225.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
hibernation worked great with 2.6.30 - I had over a month of uptime (it never 
worked so well before - always crashed after some time). But in 2.6.31, it's 
broken again - and completely. The first hibernation works but it always 
crashes on the second one.

The problem is that the oops is so long that it does not fit the screen - even 
1280x1024 is not enough. Scrolling does not work (as it used to do on 2.4 
kernels), netconsole does not catch it. So how can I debug this?

-- 
Ondrej Zary
