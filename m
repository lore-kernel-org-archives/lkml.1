Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZGJGI7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZGJGI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 02:08:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZGJGIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 02:08:50 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48982 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120AbZGJGIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 02:08:50 -0400
Subject: Re: [PATCH v2 17/18] new ARM SoC support: BCMRing
From: Artem Bityutskiy <dedekind@infradead.org>
Reply-To: dedekind@infradead.org
To: "Leo (Hao) Chen" <leochen@broadcom.com>
Cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Scott Branden <sbranden@broadcom.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C1F@SJEXCHCCR02.corp.ad.broadcom.com>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C1F@SJEXCHCCR02.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jul 2009 09:08:01 +0300
Message-Id: <1247206081.20721.361.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 10 Jul 2009 06:08:09.0664 (UTC) FILETIME=[CC9AFC00:01CA0124]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-03 at 18:45 -0700, Leo (Hao) Chen wrote:
> Hi,
> 
> This is the nand driver for the new bcmring architecture.
> 
> >From d3f98479bf28324a3472f3f637014a28ffef29ab Mon Sep 17 00:00:00 2001
> From: Leo Chen <leochen@broadcom.com>
> Date: Fri, 3 Jul 2009 17:27:16 -0700
> Subject: [PATCH 17/18] bcmring nand driver

Could you please make scripts/checkpatch.pl happy?

-- 
Best regards,
Artem Bityutskiy (Битюцкий Артём)

