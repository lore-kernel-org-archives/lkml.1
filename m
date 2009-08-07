Return-Path: <linux-kernel-owner+w=401wt.eu-S932724AbZHGPG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932724AbZHGPG0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932698AbZHGPGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:06:25 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1936 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932643AbZHGPGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:06:24 -0400
Subject: Re: [PATCH] MAINTAINERS: Add list entries
 linux-arm@vger.kernel.org and linux-arm-kernel@ to OMAP sections
From: Joe Perches <joe@perches.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-omap@vger.kernel.org, linux-arm@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090807080102.GV2358@atomide.com>
References: <1249576450.3467.25.camel@Joe-Laptop.home>
	 <20090807080102.GV2358@atomide.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 08:06:20 -0700
Message-Id: <1249657581.3467.76.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 11:01 +0300, Tony Lindgren wrote:
> * Joe Perches <joe@perches.com> [090806 19:35]:
> > Perhaps it's useful for OMAP patches and bug reports
> > to CC entries to the primary and secondary ARM lists.
> > Added a pattern entry for OMAP USB as well.
> ... I think let's not add the drivers. The related driver list
> and linux-omap list should be enough for these.

Fine by me.  I fixed up your M: entry as well.

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b1114cf..6a82733 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3660,8 +3660,10 @@ F:	drivers/video/riva/
 F:	drivers/video/nvidia/
 
 OMAP SUPPORT
-M:	"Tony Lindgren <tony@atomide.com>" <tony@atomide.com>
+M:	Tony Lindgren <tony@atomide.com>
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 W:	http://www.muru.com/linux/omap/
 W:	http://linux.omap.com/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tmlind/linux-omap-2.6.git
@@ -3671,12 +3673,16 @@ F:	arch/arm/*omap*
 OMAP CLOCK FRAMEWORK SUPPORT
 M:	Paul Walmsley <paul@pwsan.com>
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*clock*
 
 OMAP POWER MANAGEMENT SUPPORT
 M:	Kevin Hilman <khilman@deeprootsystems.com>
 L:	linux-omap@vger.kernel.org
+L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
+L:	linux-arm@vger.kernel.org
 S:	Maintained
 F:	arch/arm/*omap*/*pm*
 


