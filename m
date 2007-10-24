Return-Path: <linux-kernel-owner+w=401wt.eu-S1759210AbXJXNhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759210AbXJXNhT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXJXNhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:37:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:56683 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbXJXNhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:37:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PfEwDM8vauBx6vPJdx1KsbCDtbUn7cZ+iwtr14kSkB3ijWa8Md4y3bC+6zHa/cesyIOKUcwbSVJhT2W1iHR+W0GNj0eRd58kxgm3U1o7ajHcSo7bDGT07biUFvkM1/rc0oG+OR/XfZut2bwxHp0STY/jdyYKvjpFN3v+MUDxzfM=
Message-ID: <8bf247760710240637w686f1a2fxdf63a649787eca25@mail.gmail.com>
Date: Wed, 24 Oct 2007 19:07:02 +0530
From: Ram <vshrirama@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: kernel processes - are they really needed?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
    When i do ps -l. i see the following processes which are obviously
started by kernel.

   Could any one tell me what each of these processes do and can
anyone of them can be removed.?

PID  Uid     VmSize Stat Command
    1 root        584 S   init
    2 root            SWN [ksoftirqd/0]
    3 root            SW  [watchdog/0]
    4 root            SW< [events/0]
    5 root            SW< [khelper]
    6 root            SW< [kthread]
   23 root            SW< [kblockd/0]
   38 root            SW  [pdflush]
   39 root            SW  [pdflush]
   40 root            SW< [kswapd0]
   41 root            SW< [aio/0]
   85 root            SW  [mtdblockd]
  116 root            SWN [jffs2_gcd_mtd9]
Regards,
ram
