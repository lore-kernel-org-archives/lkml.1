Return-Path: <linux-kernel-owner+w=401wt.eu-S1759637AbXJaUNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759637AbXJaUNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754369AbXJaUNO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:13:14 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28306 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbXJaUNO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:13:14 -0400
Date: Wed, 31 Oct 2007 21:13:09 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071031201308.GK11514@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

My x60 stopped suspending about two days ago. It just freezes after
printing

Suspending console(s)

where it would normally turn everything off and the 'moon' light would
go on. Posting this message in case somebody else knows what is up, if
not I'll do a bisect on it tomorrow.

-- 
Jens Axboe

