Return-Path: <linux-kernel-owner+w=401wt.eu-S1756904AbZGJT6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904AbZGJT6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 15:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753916AbZGJT6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 15:58:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39935 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389AbZGJT6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 15:58:43 -0400
Date: Fri, 10 Jul 2009 16:58:29 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Devin Heitmueller <devin.heitmueller@gmail.com>
Subject: [PULL] Firmware for XC5000 (resend)
Message-ID: <20090710165829.177afe99@pedra.chehab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,

Please pull from:
	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-firmware.git master

For the Xceive xc5000 firmware.

We'll have soon the firmwares also for xc4000 and (hopefully) for
xc3028/xc3028l. Those firmwares are needed by a large number of modern USB TV
cards that use those small silicon tuners.

Thanks,
Mauro.
