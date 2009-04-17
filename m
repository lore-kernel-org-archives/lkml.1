Return-Path: <linux-kernel-owner+w=401wt.eu-S1758841AbZDQH27@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbZDQH27 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 03:28:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753732AbZDQH2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 03:28:50 -0400
Received: from smtp.nokia.com ([192.100.122.233]:24351 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZDQH2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 03:28:50 -0400
Subject: Re: [PATCH 1/4] [MTD] Update sysfs documentation
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>, greg@kroah.com,
       David Brownell <david-b@pacbell.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux MTD <linux-mtd@lists.infradead.org>
In-Reply-To: <a95a62fe0904082251n45504a51r1847cd25b9d88583@mail.gmail.com>
References: <a95a62fe0904082251n45504a51r1847cd25b9d88583@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Apr 2009 10:28:17 +0300
Message-Id: <1239953297.3390.242.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 17 Apr 2009 07:28:19.0300 (UTC) FILETIME=[14AC3240:01C9BF2E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 22:51 -0700, Kevin Cernekee wrote:
> Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
> 
> ---
>  Documentation/ABI/testing/sysfs-class-mtd |  125 +++++++++++++++++++++++++++++
>  1 files changed, 125 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-class-mtd

Pushed, to l2-mtd-2.6.git. This does not guarantee anything,
it just mean I'll ping dwmw2 to pull from that tree.

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

