Return-Path: <linux-kernel-owner+w=401wt.eu-S934775AbZLGJZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934775AbZLGJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 04:25:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZLGJZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 04:25:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34214 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933049AbZLGJZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 04:25:27 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/7] some page_referenced() improvement
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>, Rik van Riel <riel@redhat.com>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Larry Woodman <lwoodman@redhat.com>
In-Reply-To: <20091204173233.5891.A69D9226@jp.fujitsu.com>
References: <20091204173233.5891.A69D9226@jp.fujitsu.com>
Message-Id: <20091207182442.E94D.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon,  7 Dec 2009 18:25:30 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi
> 
> here is my refactoring and improvement patchset of page_referenced().
> I think it solve Larry's AIM7 scalability issue.
> 
> I'll test this patches on stress workload at this weekend. but I hope to
> receive guys review concurrently.

OK. this patches survived my stress workload correctly for two days of last weekend.



