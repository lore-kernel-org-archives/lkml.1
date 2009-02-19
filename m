Return-Path: <linux-kernel-owner+w=401wt.eu-S1757735AbZBSTB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757735AbZBSTB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 14:01:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206AbZBSTBa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 14:01:30 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:56754 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbZBSTB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 14:01:29 -0500
X-Auth-Info: CYDFVI/hopltSqM31+KLFYezmq0zsSPdBADA7CEuuTY=
From: Wolfgang Grandegger <wg@grandegger.com>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/8] can: CAN network device driver interface and drivers
Date: Thu, 19 Feb 2009 20:01:14 +0100
Message-Id: <1235070082-7069-1-git-send-email-wg@grandegger.com>
X-Mailer: git-send-email 1.5.6.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the PF_CAN protocol family for the Controller Area Network is available
in the kernel since version 2.6.25 but drivers for real CAN devices are
still missing. This patch series adds a generic CAN network device
driver interface and, as a start, a few drivers. It is the result of the
ongoing discussion and development of the Socket-CAN project hosted at
the BerliOS web-server (http://developer.berlios.de/projects/socketcan).
The patch series consists of the following patches:

[PATCH 1/8] can: Documentation for the CAN device driver interface
[PATCH 2/8] can: Update MAINTAINERS and CREDITS file
[PATCH 3/8] can: CAN Network device driver and SYSFS interface
[PATCH 4/8] can: Driver for the SJA1000 CAN controller
[PATCH 5/8] can: SJA1000 generic platform bus driver
[PATCH 6/8] can: SJA1000 driver for EMS PCI cards
[PATCH 7/8] can: SJA1000 driver for Kvaser PCI cards
[PATCH 8/8] can: Driver for the Freescale MSCAN controller

Please consider these patches for inclusion.

Thanks,

Wolfgang.

