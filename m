Return-Path: <linux-kernel-owner+w=401wt.eu-S1760618AbZGIN56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760618AbZGIN56 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 09:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760531AbZGIN5u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 09:57:50 -0400
Received: from mx-out2.daemonmail.net ([216.104.160.39]:58988 "EHLO
	mx-out2.daemonmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759129AbZGIN5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 09:57:50 -0400
From: "Michael S. Zick" <lkml@morethan.org>
Reply-To: lkml@morethan.org
To: linux-kernel@vger.kernel.org
Subject: EHCI, BIOS handoff warning/error?
Date: Thu, 9 Jul 2009 08:57:44 -0500
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907090857.47350.lkml@morethan.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anyone with thoughts on this one?
Even a translation of the message might help.

pci 0000:00:01.0: disabling DAC on VIA PCI bridge
pci 0000:00:10.0: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:10.0: Performing full reset
pci 0000:00:10.1: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:10.1: Performing full reset
pci 0000:00:10.2: uhci_check_and_reset_hc: legsup = 0x2000
pci 0000:00:10.2: Performing full reset
pci 0000:00:10.4: EHCI: BIOS handoff
pci 0000:00:10.4: EHCI: BIOS handoff failed (BIOS bug?) 01010001
pci 0000:01:00.0: Boot video device


Mike
