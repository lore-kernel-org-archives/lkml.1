Return-Path: <linux-kernel-owner+w=401wt.eu-S1751704AbZIXK1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751704AbZIXK1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 06:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751594AbZIXK04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 06:26:56 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53538 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZIXK0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 06:26:55 -0400
Message-ID: <65049.192.168.10.89.1253788018.squirrel@dbdmail.itg.ti.com>
Date: Thu, 24 Sep 2009 15:56:58 +0530 (IST)
Subject: [PATCHv1 0/3] OMAP UART: Adding support for omap-serial driver.
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All,

Resubmitting, After modifying patch series as per Tony's comments.

The Following series of patch adds support for OMAP3430-HIGH SPEED UART Controller.

[PATCHv1 1/3] - Adds support for omap-serial driver also includes header, Kconfig and Makefile.
                [ Patch v1- Removed SERIAL_OMAP_UARTx_RXDMA_BUFSIZE and
                 SERIAL_OMAP_UARTx_RXDMA_BUFSIZE from Kconfig, incorporated into platform data.]

[PATCHv1 2/3] - Adds platform data support for omap-serial driver.
                [ Patch v1- Incorporated rx bufsize and rx timoeout values and avoided using config
                option. ]

[PATCHv1 3/3] - Adds omap-serial driver support in omap_3430sdp_defconfig.
                [ No Changes ]

-- 
Regards,
Govindraj.R


