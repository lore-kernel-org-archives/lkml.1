Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYJURmN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYJURmN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 13:42:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYJURl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 13:41:58 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:10523 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbYJURl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 13:41:58 -0400
Message-ID: <48FE1459.5010205@oracle.com>
Date: Tue, 21 Oct 2008 10:41:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>, lkml <linux-kernel@vger.kernel.org>
Subject: -git10 staging build warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i386:

drivers/staging/sxg/sxg.c:462: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
drivers/staging/sxg/sxg.c:479: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
drivers/staging/sxg/sxg.c:540: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'
drivers/staging/sxg/sxg.c:571: warning: format '%lx' expects type 'long unsigned int', but argument 3 has type 'unsigned int'

x86_64:

drivers/staging/winbond/./linux/wbusb .c:109: warning: 'struct ieee80211_tx_control' declared inside parameter list drivers/staging/winbond/./linux/wbusb.c:109: warning: its scope is only this definition or declaration, which is proba bly not what you want
drivers/staging/winbond/./linux/wbusb .c:172: warning: initialization from incompatible pointer type
drivers/staging/winbond/./linux/wbusb .c:174: warning: initialization from incompatible pointer type
drivers/staging/winbond/./linux/wbusb .c:180: warning: initialization from incompatible pointer type
drivers/staging/winbond/./linux/wbusb .c:181: warning: initialization from incompatible pointer type
drivers/staging/winbond/./linux/wbusb .c:299: warning: ISO C90 forbids mixed declarations and code
drivers/staging/usbip/vhci_rx.c:204: warning: format '%d' expects type 'int', but argument 7 has type 'long unsigned int'
drivers/staging/winbond/sme_api.c:13: warning: no return statement in function returning non-void
