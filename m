Return-Path: <linux-kernel-owner+w=401wt.eu-S1753763AbZCXCAZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753763AbZCXCAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 22:00:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbZCXCAI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 22:00:08 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:35254 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbZCXCAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 22:00:08 -0400
Message-ID: <49C83EA4.8060108@mnementh.co.uk>
Date: Tue, 24 Mar 2009 02:00:04 +0000
From: Ian Molton <ian@mnementh.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Pierre Ossman <drzeus@drzeus.cx>
CC: Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
       drzeus-wbsd@drzeus.cx, akpm@linux-foundation.org
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se> <20090316193010.56644165@mjolnir.ossman.eu>
In-Reply-To: <20090316193010.56644165@mjolnir.ossman.eu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:

> Ian, I noticed that there isn't a MAINTAINERS entry for this driver.
> Care to send me a patch to remedy that?

Something like this?

diff --git a/MAINTAINERS b/MAINTAINERS
index 5d460c9..6dd8805 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4298,6 +4298,11 @@ L:	tlinux-users@tce.toshiba-dme.co.jp
  W:	http://www.buzzard.org.uk/toshiba/
  S:	Maintained

+TMIO MMC DRIVER
+P:	Ian Molton
+M:	ian@mnementh.co.uk
+S:	Maintained
+
  TPM DEVICE DRIVER
  P:	Debora Velarde
  M:	debora@linux.vnet.ibm.com
