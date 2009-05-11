Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZEKI5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZEKI5v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 04:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756630AbZEKI5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 04:57:00 -0400
Received: from sh.osrg.net ([192.16.179.4]:37527 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825AbZEKI47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 04:56:59 -0400
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: jens.axboe@oracle.com
Cc: tj@kernel.org, James.Bottomley@HansenPartnership.com, bharrosh@panasas.com,
       fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] block: completion releated functions cleanup
Date: Mon, 11 May 2009 17:56:06 +0900
Message-Id: <1242032169-22422-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.6.0.6
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 11 May 2009 17:55:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a minor cleanup on the completion releated functions. It is on
the top of Tejun's unify request processing model patchset.


