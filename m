Return-Path: <linux-kernel-owner+w=401wt.eu-S1761138AbYEAPma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761138AbYEAPma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 11:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752065AbYEAPmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 11:42:23 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:45497 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbYEAPmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 11:42:22 -0400
MIME-Version: 1.0
Date: Thu, 01 May 2008 17:42:15 +0200
From: <oliver@zipernowsky.hu>
To: linux-kernel@vger.kernel.org
Cc: Jeff Moyer <jmoyer@redhat.com>
Subject: [OP] v2.6.22.22-op2-rc1
Reply-To: oliver.pntr@gmail.com
Message-ID: <14a96e5f5f50a2822b7b2a223ad3288f@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux v2.6.22.22-op2-rc1
  "stable" review patch
 
  what is this tree?
  it is my long term supported kernel, when i have time for it, i
  backported the most important fixes.
 
  http://repo.or.cz/w/linux-2.6.22.y-op.git rc
  http://repo.or.cz/w/linux-2.6.22.y-op-patches.git

---
Makefile |    2 +-
 fs/aio.c |    7 ++++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

---

Jeff Moyer (1):
      aio: only account I/O wait time in read_events if there are active
requests

Oliver Pinter (1):
      v2.6.22.22-op2-rc1

---




