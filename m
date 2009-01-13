Return-Path: <linux-kernel-owner+w=401wt.eu-S1759507AbZAMNuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759507AbZAMNuM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 08:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZAMNtx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 08:49:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50453 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482AbZAMNtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 08:49:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 0/7] PCI Express port driver fixes and cleanups (rev. 2)
Date: Tue, 13 Jan 2009 14:34:28 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.29-rc1-rjw; KDE/4.1.3; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200901131434.28340.rjw@sisk.pl>
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second iteration of the series of patches containing fixes and
cleanups of the PCI Express port driver.  Apart from bug fixes the patches
generally remove unnecessary things from the driver and simplify the code.
The last patch adds support for the new PCI PM framework.

I've tested these patches on a couple of machines and I'm quite confident that
they don't break things, but still more testing is always recommended. :-)

Please consider for applying.

Thanks,
Rafael

