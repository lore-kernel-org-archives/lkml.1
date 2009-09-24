Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbZIXOkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbZIXOkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752653AbZIXOkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:40:36 -0400
Received: from brick.kernel.dk ([93.163.65.50]:44104 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZIXOkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:40:35 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: fengguang.wu@intel.com, shaohua.li@intel.com, chris.mason@oracle.com,
       jack@suse.cz
Subject: [PATCH 0/10] Current writeback patch queue
Date: Thu, 24 Sep 2009 16:40:26 +0200
Message-Id: <1253803236-20760-1-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.3.385.g60647
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the current writeback patch queue. Most of the patches
have already been reviewed and acked, but please take a look
at the ones that have not (and ack/comment as necessary).

Wu, this one is still missing the 5/6 patch from your latest posting,
Please double check and re-submit that bit. Thanks!

As usual, the current queue can always be checked out from:

  git://git.kernel.dk/linux-2.6-block.git writeback

-- 
Jens Axboe <jens.axboe@oracle.com>

