Return-Path: <linux-kernel-owner+w=401wt.eu-S2992820AbXDTJfT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992820AbXDTJfT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 05:35:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992795AbXDTJfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 05:35:19 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41300 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992773AbXDTJfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 05:35:18 -0400
Date: Fri, 20 Apr 2007 10:38:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: InitIO SCSI: Volunteers required
Message-ID: <20070420103849.7358f1f1@the-village.bc.nu>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking for some testers for a revamp of the initio driver. No real
code changes other than to hopefully stop it exploding on load on 64bit,
but a major reorganisation, commenting and "de-windowsification" so the
code is actually readable and I can do the pci_find_device to
pci_get_device transitions.

Alan
