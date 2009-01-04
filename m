Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZADIW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZADIW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 03:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZADIWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 03:22:41 -0500
Received: from jaguar.mkp.net ([192.139.46.146]:52466 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbZADIWl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 03:22:41 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 0 of 3] Block Layer Data Integrity Fixes
Message-Id: <patchbomb.1231055017@sermon.lab.mkp.net>
Date: Sun, 04 Jan 2009 02:43:37 -0500
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Block integrity updates for 2.6.29.

3 files changed, 29 insertions(+), 23 deletions(-)
block/blk-integrity.c |   25 ++++++++++++++-----------
fs/bio-integrity.c    |   26 +++++++++++++++-----------
include/linux/bio.h   |    1 -


