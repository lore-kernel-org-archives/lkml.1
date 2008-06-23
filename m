Return-Path: <linux-kernel-owner+w=401wt.eu-S1754070AbYFWLYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbYFWLYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 07:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYFWLYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 07:24:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33268 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751867AbYFWLYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 07:24:36 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 0/2] TTY cleanups
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Date: Mon, 23 Jun 2008 12:06:20 +0100
Message-ID: <20080623110455.24976.32969.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Two small tty clean ups.

---

Alan Cox (1):
      tty_driver: Update required method documentation

Gustavo Fernando Padovan (1):
      removed unused var real_tty on n_tty_ioctl()


 drivers/char/tty_ioctl.c   |    7 -------
 include/linux/tty_driver.h |    5 ++---
 2 files changed, 2 insertions(+), 10 deletions(-)

-- 
With trembling hands he unfurled the ancient cracked parchment, this was
the place, it had to be. Uncertainly he began to mumble the chant "rdbms,
sql , third normal form, java,  table, scalable". Something moved..
>From outside they heard a scream and a thud. The sales department had awoken

