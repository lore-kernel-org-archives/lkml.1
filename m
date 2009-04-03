Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbZDCHKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbZDCHKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 03:10:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbZDCHKC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 03:10:02 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51869 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbZDCHKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 03:10:01 -0400
Subject: Re: [patch/rfc 2.6.29 1/2] MTD: driver model updates
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: Kevin Cernekee <kpc.mtd@gmail.com>
Cc: david-b@pacbell.net, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1238742215.20906.99.camel@localhost.localdomain>
References: <200903260042.42091.david-b@pacbell.net>
	 <a95a62fe0904021641j17a7c26dv5652de4a19bad662@mail.gmail.com>
	 <1238742215.20906.99.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 03 Apr 2009 10:09:40 +0300
Message-Id: <1238742580.20906.104.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 03 Apr 2009 07:09:41.0999 (UTC) FILETIME=[28ED17F0:01C9B42B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-04-03 at 10:03 +0300, Artem Bityutskiy wrote:
> On Thu, 2009-04-02 at 16:41 -0700, Kevin Cernekee wrote:
> > Here is a follow-up patch to apply on top of David Brownell's original
> > MTD driver model patch at:
> > 
> > http://lists.infradead.org/pipermail/linux-mtd/2009-March/025005.html
> > 
> > Changes:
> > 
> > 1) Add more sysfs attributes: mtd_flags, mtd_size, mtd_erasesize,
> > mtd_writesize, mtd_oobsize, mtd_numeraseregions, mtd_name .
> 
> Please, do not all the "mtd_" prefix to the file names. This is
> redundant information because we already know this is about
> mtd from the path.

Sorry, s/all/add/.
-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

