Return-Path: <linux-kernel-owner+w=401wt.eu-S1752374AbXI3TZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752374AbXI3TZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 15:25:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751564AbXI3TZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 15:25:24 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:35471 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbXI3TZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 15:25:23 -0400
Message-ID: <46FFF81A.2080909@mandic.com.br>
Date: Sun, 30 Sep 2007 16:25:14 -0300
From: "Renato S. Yamane" <renatoyamane@mandic.com.br>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: When come back from RAM, lcd brightness is changed
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

uname -a
Linux mandachuva 2.6.22.9-cfs-v22 #2 PREEMPT Sun Sep 30 15:21:17 BRT 
2007 i686 GNU/Linux

Distro: Debian Etch

When I use KPowersave and click on "Suspend to RAM", my laptop Toshiba 
M45-S355 "sleep" and "wake-up" very well, but LCD Brightness is changed 
to MAX (I hate this "sunshine" on my eyes).

One more detail: Kernel Linux don't have control of lcd brightness, so I 
need use omnibook driver to do this (<http://omnibook.sourceforge.net>).

Regards,
Renato
