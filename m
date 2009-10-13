Return-Path: <linux-kernel-owner+w=401wt.eu-S933652AbZJMNcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933652AbZJMNcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbZJMNcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:32:16 -0400
Received: from violet.abc.se ([62.80.200.155]:44985 "EHLO violet.abc.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759623AbZJMNcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 09:32:16 -0400
X-Greylist: delayed 3809 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Oct 2009 09:32:15 EDT
Message-ID: <4AD47201.7000400@abc.se>
Date: Tue, 13 Oct 2009 14:26:41 +0200
From: Bo Forslund <bo.forslund@abc.se>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090706)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: answer to "Please submit a full bug report" kernel 2.6.31.4
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2 (violet.abc.se [62.80.200.155]); Tue, 13 Oct 2009 14:28:09 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got this error messages when trying to build a custom kernel. I don't 
know if it is the kernel source or the compiler that is failing. It is 
an out-of-the-box Debian Squeeze system on an old dual cpu bp6 machine.


The word "Fel" below translate to Error.

CC drivers/firmware/iscsi_ibft_find.o
CC drivers/firmware/iscsi_ibft.o
drivers/firmware/iscsi_ibft.c: In function ‘ibft_init’:
drivers/firmware/iscsi_ibft.c:968: internal compiler error: in 
purge_dead_edges, at cfgrtl.c:2350
Please submit a full bug report,
with preprocessed source if appropriate.
See <file:///usr/share/doc/gcc-4.3/README.Bugs> for instructions.
make[3]: *** [drivers/firmware/iscsi_ibft.o] Fel 1
make[2]: *** [drivers/firmware] Fel 2
make[1]: *** [drivers] Fel 2
make[1]: Leaving directory `/usr/src/linux-2.6.31.4'
make: *** [debian/stamp/build/kernel] Fel 2
bo@pc88:/usr/src/linux$



Regards
Bo
