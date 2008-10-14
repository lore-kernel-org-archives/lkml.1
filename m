Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYJNK2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYJNK2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 06:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbYJNK2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 06:28:40 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37325 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754801AbYJNK2k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 06:28:40 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Series short description
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 14 Oct 2008 11:28:34 +0100
Message-ID: <20081014102821.20626.97298.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix up the 8250 locking
---

Alan Cox (1):
      8250: Fix lock warning


 drivers/serial/8250.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

