Return-Path: <linux-kernel-owner+w=401wt.eu-S1757536AbZFVPFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757536AbZFVPFy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 11:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbZFVPFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 11:05:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37423 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751337AbZFVPFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 11:05:46 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] Parallel port fixes for 2.6.31
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 16:47:37 +0100
Message-ID: <20090622154702.17809.58975.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


---

FUJITA Tomonori (1):
      parport_pc: set properly the dma_mask for parport_pc device

Jens Rottmann (1):
      parport_pc: after superio probing restore original register values


 drivers/parport/parport_pc.c            |   34 +
