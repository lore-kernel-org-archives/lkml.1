Return-Path: <linux-kernel-owner+w=401wt.eu-S1759367AbZJGO5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759367AbZJGO5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759325AbZJGO5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:57:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56329 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754023AbZJGO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:57:18 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 0/4] tty_port use for isicom
To: linux-kernel@vger.kernel.org, strakh@ispras.ru, jirislaby@gmail.com
Date: Wed, 07 Oct 2009 15:46:04 +0100
Message-ID: <20091007144455.14550.95003.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pending patch proposal plus the isicom fix on the end. Could do with a good
review Jiri.

Signed-off-by: Alan Cox <alan@linux.intel.com>

---

Alan Cox (4):
      isicom: fix deadlock on shutdown
      isicom: sort out the board init logic
      isicom: switch to the new tty_port_open helper
      tty_port: add "tty_port_open" helper

--
Two fish in a tank: One says to the other "Can you drive this ?"

