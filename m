Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab0B0HPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 02:15:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:52979 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab0B0HPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 02:15:01 -0500
Subject: Watchdog: How to get rid of warning
 =?UTF-8?Q?=E2=80=98esb=5Fpci=5Ftbl=E2=80=99?= defined but not used
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Wim Van Sebroeck <wim@iguana.be>, Ross Biro <rossb@google.com>,
       David Hardeman <david@2gen.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Feb 2010 12:42:59 +0530
Message-Id: <1267254779.25446.10.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Various people pointed this warning but it is still not fixed :

 CC      drivers/watchdog/i6300esb.o
drivers/watchdog/i6300esb.c:341: warning: ‘esb_pci_tbl’ defined but not used

Is any special reason to keep this warning.

Thanks,
--
Jaswinder.


