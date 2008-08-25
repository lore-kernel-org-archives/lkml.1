Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYHYWBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYHYWBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 18:01:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYHYWBk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 18:01:40 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:48171 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbYHYWBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 18:01:39 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: [PATCH 0/5] use lspci style for [%04x:%04x] vendor/device
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Aug 2008 16:01:38 -0600
Message-ID: <20080825220137.19210.41857.stgit@tigger.helgaas>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches change various debug messages to use "[%04x:%04x]" for
PCI vendor/device IDs to follow the format used by lspci(8).

Bjorn
