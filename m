Return-Path: <linux-kernel-owner+w=401wt.eu-S1758905AbZDQHbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758905AbZDQHbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:31:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758530AbZDQHaj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:30:39 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24667 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbZDQHai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:30:38 -0400
Subject: Re: [PATCH 2/4] [MTD] Add MEMERASE64 ioctl for >4GiB devices
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
       Linux MTD <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <a95a62fe0904082252h41afa872j2ef6fb9d1d76dc27@mail.gmail.com>
References: <a95a62fe0904082252h41afa872j2ef6fb9d1d76dc27@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Apr 2009 10:30:16 +0300
Message-Id: <1239953416.3390.243.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Apr 2009 07:30:17.0988 (UTC) FILETIME=[5B6A8C40:01C9BF2E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 22:52 -0700, Kevin Cernekee wrote:
> New MEMERASE/MEMREADOOB/MEMWRITEOOB ioctls are needed in order to support
> 64-bit offsets into large NAND flash devices.
> 
> Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
> 

Kevin, are you going to re-send patches 2-4, taking into account
Arnd's and Andrew's suggestions?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

