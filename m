Return-Path: <linux-kernel-owner+w=401wt.eu-S1751968AbZGOF2Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968AbZGOF2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 01:28:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751005AbZGOF2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 01:28:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:35759 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbZGOF2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 01:28:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 0/5] Memory controller soft limit patches (v9)
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
In-Reply-To: <20090715040811.GF24034@balbir.in.ibm.com>
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop> <20090715040811.GF24034@balbir.in.ibm.com>
Message-Id: <20090715142736.39AA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 15 Jul 2009 14:28:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-07-10 18:29:50]:
> 
> > 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > New Feature: Soft limits for memory resource controller.
> > 
> > Here is v9 of the new soft limit implementation. Soft limits is a new feature
> > for the memory resource controller, something similar has existed in the
> > group scheduler in the form of shares. The CPU controllers interpretation
> > of shares is very different though. 
> >
> 
> If there are no objections to these patches, could we pick them up for
> testing in mmotm. 

Sorry, I haven't review this patch series. please give me few days.


