Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbZG1SUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbZG1SUX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 14:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755341AbZG1SUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 14:20:22 -0400
Received: from hawking.rebel.net.au ([203.20.69.83]:60854 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755333AbZG1SUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 14:20:21 -0400
Message-ID: <4A6F4160.4080900@davidnewall.com>
Date: Wed, 29 Jul 2009 03:50:16 +0930
From: David Newall <davidn@davidnewall.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: Regression impacts ServeRAID II on IBM xSeries 5500
References: <4A6172F0.60707@davidnewall.com>	<20090723110118N.fujita.tomonori@lab.ntt.co.jp>	<4A69D341.8030908@davidnewall.com> <20090728114207C.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090728114207C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> I merged lots of changes to sg in 2.6.28. I fixed several bugs due to
> it (the last one was merged in 2.6.31-rc3). Can you try the
> 2.6.31-rc4?
>   

Yes, that works. Thank you very much.
