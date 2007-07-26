Return-Path: <linux-kernel-owner+w=401wt.eu-S932259AbXGZR2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932259AbXGZR2g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 13:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761321AbXGZR23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 13:28:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:59399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760858AbXGZR23 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 13:28:29 -0400
Message-Id: <20070726172504.415412586@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 26 Jul 2007 19:25:04 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       containers@lists.osdl.org
Cc: akpm@linux-foundation.org, balbir@linux.vnet.ibm.com, riel@redhat.com,
       a.p.zijlstra@chello.nl
Subject: [PATCH 0/2] refaults
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a brush up of the refault patches, as presented by Rik at last
year's OLS:

  http://people.redhat.com/riel/riel-OLS2006.pdf

When talking to people at OLS this year there was a renewed interrest in
the concept.


