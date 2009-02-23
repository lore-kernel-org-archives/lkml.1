Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZBWMjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZBWMjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 07:39:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZBWMix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 07:38:53 -0500
Received: from adelie.canonical.com ([91.189.90.139]:56616 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbZBWMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 07:38:52 -0500
From: Andy Whitcroft <apw@canonical.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Andy Whitcroft <apw@canonical.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] mmc-modalias-v2r1
Date: Mon, 23 Feb 2009 12:38:40 +0000
Message-Id: <1235392721-22545-1-git-send-email-apw@canonical.com>
X-Mailer: git-send-email 1.6.1.2.419.g0d87e
In-Reply-To: <20090218205654.05896ece@mjolnir.ossman.eu>
References: <20090218205654.05896ece@mjolnir.ossman.eu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

*** BLURB HERE ***

Andy Whitcroft (1):
  mmc: add MODALIAS linkage for MMC/SD devices

 drivers/mmc/card/block.c |    2 ++
 drivers/mmc/core/bus.c   |    8 ++++++++
 2 files changed, 10 insertions(+), 0 deletions(-)

