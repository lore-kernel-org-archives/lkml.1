Return-Path: <linux-kernel-owner+w=401wt.eu-S1756866AbZJBBeD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866AbZJBBeD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:34:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756830AbZJBBd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:59 -0400
Received: from kroah.org ([198.145.64.141]:33369 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756797AbZJBBdr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:47 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:21 2009
Message-Id: <20091002012421.321857773@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:17:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Luca Tettamanti <kronos.it@gmail.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: [091/136] hwmon: (asus_atk0110) Add maintainer information
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=hwmon-add-maintainer-information.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Luca Tettamanti <kronos.it@gmail.com>

commit 2c2a6172afab7421f6af7e228cd3121f423ea932 upstream.

Add myself as asus_atk0110 maintainer.

Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 MAINTAINERS |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -897,6 +897,12 @@ W:	http://wireless.kernel.org/en/users/D
 S:	Maintained
 F:	drivers/net/wireless/ath/ar9170/
 
+ATK0110 HWMON DRIVER
+M:	Luca Tettamanti <kronos.it@gmail.com>
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+F:	drivers/hwmon/asus_atk0110.c
+
 ATI_REMOTE2 DRIVER
 M:	Ville Syrjala <syrjala@sci.fi>
 S:	Maintained


