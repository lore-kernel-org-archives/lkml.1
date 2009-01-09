Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZAIScZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZAIScZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:32:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752732AbZAIScQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:32:16 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:48833 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbZAIScQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:32:16 -0500
X-IronPort-AV: E=Sophos;i="4.37,240,1231131600"; 
   d="scan'208";a="35161170"
From: Ian Campbell <Ian.Campbell@citrix.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, jj@chaosbits.net,
       weiyi.huang@gmail.com, Becky Bruce <beckyb@kernel.crashing.org>
Subject: [PATCH 0/2] Re: swiotlb: remove duplicated #include
Date: Fri,  9 Jan 2009 18:32:08 +0000
Message-Id: <1231525930-14087-1-git-send-email-Ian.Campbell@citrix.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231524630.27350.79.camel@zakaz.uk.xensource.com>
References: <1231524630.27350.79.camel@zakaz.uk.xensource.com>
X-OriginalArrivalTime: 09 Jan 2009 18:32:14.0823 (UTC) FILETIME=[98031F70:01C97288]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 18:10 +0000, Ian Campbell wrote:

> Patch is against Jeremy's Xen patch queue which is based on a pre-Xmas
> tip tree so fairly out of date, I hope it is somewhat useful though.

Here's a version again tip-latest, only compile tested though since my
testing relies on the Xen dom0 patch queue.

