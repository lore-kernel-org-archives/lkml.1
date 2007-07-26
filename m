Return-Path: <linux-kernel-owner+w=401wt.eu-S936666AbXGZU3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936666AbXGZU3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 16:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936259AbXGZU3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 16:29:22 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:37878 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936040AbXGZU3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 16:29:20 -0400
From: Ismail =?utf-8?q?D=C3=B6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: linux-kernel@vger.kernel.org
Subject: New ACPI error/warning with Linus' latest GIT
Date: Thu, 26 Jul 2007 23:29:20 +0300
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707262329.20478.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This time on a HP Pavillion DV2000 ,

ACPI: EC: GPE = 0x17, I/O: command/status = 0x66, data = 0x62<6>ACPI: PCI Root 
Bridge [PCI0] (0000:00)
ACPI: EC: Handler for query 0x57 is not found!

Seems to be a new warning/error, too noisy debugging again?

Regards,
ismail

-- 
Perfect is the enemy of good
