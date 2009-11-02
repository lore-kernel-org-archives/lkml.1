Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbZKBRGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbZKBRGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 12:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755464AbZKBRGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 12:06:47 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55713 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755191AbZKBRGq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 12:06:46 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] And one more sdio_uart item
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, nico@cam.org
Date: Mon, 02 Nov 2009 16:53:23 +0000
Message-ID: <20091102165251.12075.20588.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I suppose it would help if I sent the patch that goes before the sdio cleanup
---

Alan Cox (1):
      sdio_uart: use tty_port


 drivers/mmc/card/sdio_uart.c |   41 +++++++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 18 deletions(-)

-- 
Duh...

