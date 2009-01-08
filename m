Return-Path: <linux-kernel-owner+w=401wt.eu-S1761497AbZAHXv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761497AbZAHXv6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 18:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZAHXvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 18:51:49 -0500
Received: from vena.lwn.net ([206.168.112.25]:40851 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZAHXvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 18:51:49 -0500
Date: Thu, 8 Jan 2009 16:51:31 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Linux Foundation TAB <tech-board@lists.linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David John <davidjon@xenontk.org>
Subject: [PULL] BKL removal tree
Message-ID: <20090108165131.5d432abc@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Linus,

Once again, the BKL removal tree has all of one patch, cleaning up the
RTC driver.  Please pull:

  git://git.lwn.net/linux-2.6.git bkl-removal

David John (1):
      RTC: Remove the BKL.

 drivers/char/rtc.c |   17 ++++-------------
 1 files changed, 4 insertions(+), 13 deletions(-)

Thanks,

jon
