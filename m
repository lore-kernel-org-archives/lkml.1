Return-Path: <linux-kernel-owner+w=401wt.eu-S966706AbXJPWT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966706AbXJPWT6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 18:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966600AbXJPWSv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 18:18:51 -0400
Received: from www17.your-server.de ([213.133.104.17]:44141 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966597AbXJPWSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 18:18:50 -0400
Message-ID: <471538C2.80806@m3y3r.de>
Date: Wed, 17 Oct 2007 00:18:42 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 2.0.0.6 (X11/20070803)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: hda-intel: no soundcard with current linus' git tree
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

$ dmesg

[schnipp]

ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 21
PCI: Enabling bus mastering for device 0000:00:1b.0
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: STAC922x, Apple subsys_id=106b0200
ACPI: PCI interrupt for device 0000:00:1b.0 disabled
HDA Intel: probe of 0000:00:1b.0 failed with error -16

[schnipp]


