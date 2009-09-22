Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZIVREJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZIVREJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 13:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755994AbZIVREI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 13:04:08 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:40053 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751597AbZIVREH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 13:04:07 -0400
Message-ID: <50933.192.168.10.88.1253639050.squirrel@dbdmail.itg.ti.com>
Date: Tue, 22 Sep 2009 22:34:10 +0530 (IST)
Subject: [PATCH 0/3] OMAP UART: Adding support for omap-serial driver.
From: "Govindraj.R" <govindraj.raja@ti.com>
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
References: 
In-Reply-To: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The Following series of patch adds support for OMAP3430-HIGH SPEED UART Controller.

[PATCH 1/3] - Adds support for omap-serial driver also includes header, Kconfig and Makefile.

[PATCH 2/3] - Adds platform data support for omap-serial driver.

[PATCH 3/3] - Adds omap-serial driver support in omap_3430sdp_defconfig.

-- 
Regards,
Govindraj.R





