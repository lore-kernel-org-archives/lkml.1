Return-Path: <linux-kernel-owner+w=401wt.eu-S1756483AbZCER63@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbZCER63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 12:58:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754638AbZCER6U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 12:58:20 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57082 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754077AbZCER6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 12:58:20 -0500
Date: Thu, 5 Mar 2009 09:58:16 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [PATCH] lm90: Update Documentation/hwmon/lm90 to reflect
	max6648/92 support
Message-ID: <20090305175816.GF6502@plum>
Reply-To: djwong@us.ibm.com
References: <20090302210106.GD6550@plum> <20090305152517.4e0b8983@hyperion.delvare> <20090305154729.GL6550@plum> <20090305174418.02fd9593@hyperion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305174418.02fd9593@hyperion.delvare>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oops, forgot this piece.
---
Update Documentation/hwmon/lm90 to add max6648/92 support.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 Documentation/hwmon/lm90 |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/Documentation/hwmon/lm90 b/Documentation/hwmon/lm90
index 0e84117..ab36eb0 100644
--- a/Documentation/hwmon/lm90
+++ b/Documentation/hwmon/lm90
@@ -42,6 +42,11 @@ Supported chips:
     Addresses scanned: I2C 0x4e
     Datasheet: Publicly available at the Maxim website
                http://www.maxim-ic.com/quick_view2.cfm/qv_pk/3497
+  * Maxim MAX6648/MAX6692
+    Prefix: 'max6646'
+    Addresses scanned: I2C 0x4c
+    Datasheet: Publicly available at the Maxim website
+               http://www.maxim-ic.com/getds.cfm/qv_pk/3500
   * Maxim MAX6649
     Prefix: 'max6646'
     Addresses scanned: I2C 0x4c
