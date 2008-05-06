Return-Path: <linux-kernel-owner+w=401wt.eu-S1761336AbYEFFmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761336AbYEFFmg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753468AbYEFFm1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:42:27 -0400
Received: from mga09.intel.com ([134.134.136.24]:11997 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753239AbYEFFm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:42:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,441,1204531200"; 
   d="scan'208";a="380398586"
Subject: Re: volanoMark regression with kernel 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1210039590.3453.18.camel@ymzhang>
References: <1210039590.3453.18.camel@ymzhang>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 06 May 2008 13:41:40 +0800
Message-Id: <1210052500.3453.21.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-05-06 at 10:06 +0800, Zhang, Yanmin wrote:

> ﻿
> AIM7 (use tmpfs) also has ﻿more than 40% on my 8-core stoakley, 16-core tigerton,
> and Itanium Montecito, but I verified that aim7 regression isn't caused by above
> patch. I am doing new bisect to check aim7 now.
AIM7 regression is caused by another patch of semaphore restructure. I will send
emails on aim7 in another thread.

-yanmin



