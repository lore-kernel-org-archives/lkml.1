Return-Path: <linux-kernel-owner+w=401wt.eu-S932079AbXGOBHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbXGOBHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 21:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760049AbXGOBHf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 21:07:35 -0400
Received: from mx34.mail.ru ([194.67.23.200]:11629 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758711AbXGOBHf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 21:07:35 -0400
X-Greylist: delayed 2862 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2007 21:07:35 EDT
Date: Sun, 15 Jul 2007 05:02:56 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: [PATCH] MAINTAINERS: Add maintainers for power supply subsystem
	and drivers (was [PATCH] pda_power: clean up irq, timer, return
	usage)
Message-ID: <20070715010256.GA6167@zarina>
Reply-To: cbou@mail.ru
References: <20070714231204.GA23582@havoc.gtf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070714231204.GA23582@havoc.gtf.org>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 14, 2007 at 07:12:04PM -0400, Jeff Garzik wrote:
> P.S.  Where are the MAINTAINERS entries for this driver, and
> drivers/power in general?

Collecting acks. David?

From: Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH] MAINTAINERS: Add maintainers for power supply subsystem and drivers

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 MAINTAINERS |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 845fbf4..3ccefac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2863,6 +2863,17 @@ M:	george@mvista.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
 
+POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
+P:	Anton Vorontsov
+M:	cbou@mail.ru
+P:	David Woodhouse
+M:	dwmw2@infradead.org
+L:	linux-kernel@vger.kernel.org
+L:	kernel-discuss@handhelds.org
+T:	git git.infradead.org/~cbou/battery2-2.6.git
+T:	git git.infradead.org/~dwmw2/battery-2.6.git
+S:	Maintained
+
 POWERPC 4xx EMAC DRIVER
 P:	Eugene Surovegin
 M:	ebs@ebshome.net
-- 
1.5.1.1-dirty
