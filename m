Return-Path: <linux-kernel-owner+w=401wt.eu-S1751324AbZGOERQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751324AbZGOERQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 00:17:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbZGOERO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 00:17:14 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:40624 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751122AbZGOERE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 00:17:04 -0400
Date: Wed, 15 Jul 2009 09:38:11 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH 0/5] Memory controller soft limit patches (v9)
Message-ID: <20090715040811.GF24034@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090710125950.5610.99139.sendpatchset@balbir-laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Balbir Singh <balbir@linux.vnet.ibm.com> [2009-07-10 18:29:50]:

> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> New Feature: Soft limits for memory resource controller.
> 
> Here is v9 of the new soft limit implementation. Soft limits is a new feature
> for the memory resource controller, something similar has existed in the
> group scheduler in the form of shares. The CPU controllers interpretation
> of shares is very different though. 
>

If there are no objections to these patches, could we pick them up for
testing in mmotm. 

-- 
	Balbir
