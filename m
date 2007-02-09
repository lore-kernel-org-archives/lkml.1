Return-Path: <linux-kernel-owner+w=401wt.eu-S1423130AbXBITCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423130AbXBITCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 14:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423209AbXBITCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 14:02:44 -0500
Received: from brick.kernel.dk ([62.242.22.158]:8218 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423130AbXBITCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 14:02:43 -0500
Date: Fri, 9 Feb 2007 20:03:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: current git breaks resume
Message-ID: <20070209190307.GC6152@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Unfortunately I'm a little short on time as I'll be travelling tomorrow,
but of course preparing a new kernel for the laptop is something you
want to do right before leaving. So I discovered that the current (well
as of yesterday, HEAD is 5986a2ec35836a878350c54af4bd91b1de6abc59)
doesn't resume on my x60. 2.6.20 works fine, so something broke since
then.

-- 
Jens Axboe

