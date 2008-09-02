Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbYIBM2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbYIBM2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 08:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYIBM2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 08:28:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:44956 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYIBM2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 08:28:03 -0400
Message-ID: <48BD30F9.6080108@kernel.org>
Date: Tue, 02 Sep 2008 14:26:33 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: device@lanana.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: regarding major number of block extended devt
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 02 Sep 2008 12:27:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Extended devt is scheduled for 2.6.28 merge and is currently using 259.
 Can extended devt keep this major or should it use something else?

Thanks.

-- 
tejun
