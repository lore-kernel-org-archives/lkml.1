Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbZADXC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbZADXC0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 18:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751840AbZADXBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 18:01:33 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49616 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751831AbZADXBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 18:01:30 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/8] PCI Express port driver fixes and cleanups
Date: Sun, 4 Jan 2009 23:46:42 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.28-rjw; KDE/4.1.3; x86_64; ; )
Cc: Linux PCI <linux-pci@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901042346.42723.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series of patches contains some fixes and cleanups of the PCI Express
port driver.  Apart from bug fixes the patches remove unnecessary things from
the driver.

The patches are on top of the other series I sent a couple of days ago
(http://marc.info/?l=linux-pci&m=123083608411848&w=4,
http://marc.info/?l=linux-pci&m=123083608311844&w=4,
http://marc.info/?l=linux-pci&m=123083608711856&w=4,
http://marc.info/?l=linux-pci&m=123083608311840&w=4).

Please tell me what you think.

Thanks,
Rafael

