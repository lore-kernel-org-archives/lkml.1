Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbZKYKOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbZKYKOn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbZKYKOl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:14:41 -0500
Received: from smtp.nokia.com ([192.100.105.134]:18215 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758620AbZKYKOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:14:39 -0500
From: Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>
To: lrg@slimlogic.co.uk, broonie@opensource.wolfsonmicro.com,
       dbrownell@users.sourceforge.net, sameo@linux.intel.com,
       linux-kernel@vger.kernel.org
Cc: peter.de-schrijver@nokia.com, eduardo.valentin@nokia.com,
       ext-juha.1.keski-saari@nokia.com
Subject: [PATCHv2 0/1] twl4030-mfd: Add all twl4030 regulators to RegFW
Date: Wed, 25 Nov 2009 12:14:01 +0200
Message-Id: <1259144042-9662-1-git-send-email-ext-juha.1.keski-saari@nokia.com>
X-Mailer: git-send-email 1.6.3.3
X-OriginalArrivalTime: 25 Nov 2009 10:14:05.0063 (UTC) FILETIME=[0483B170:01CA6DB8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is a revision of an earlier patch. The previous content was split
and now these changes are against sound-2.6/twl4030-mfd.

These are only modifications on the twl4030 mfd driver, changes to the
regulator driver were sent separately

BR,

Juha Keski-Saari (1):
  twl4030-mfd: Add all twl4030 regulators to the twl4030 mfd driver

 drivers/mfd/twl4030-core.c  |   26 ++++++++++++++++++++++++--
 include/linux/i2c/twl4030.h |    8 ++++++--
 2 files changed, 30 insertions(+), 4 deletions(-)

