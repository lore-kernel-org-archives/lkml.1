Return-Path: <linux-kernel-owner+w=401wt.eu-S1752061AbZGOFcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752061AbZGOFcc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 01:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbZGOFcb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 01:32:31 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54276 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbZGOFca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 01:32:30 -0400
Date: Wed, 15 Jul 2009 11:02:22 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/5] Memory controller soft limit patches (v9)
Message-ID: <20090715053222.GH24034@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090710125950.5610.99139.sendpatchset@balbir-laptop> <20090715040811.GF24034@balbir.in.ibm.com> <20090715142736.39AA.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090715142736.39AA.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> [2009-07-15 14:28:19]:

> > * Balbir Singh <balbir@linux.vnet.ibm.com> [2009-07-10 18:29:50]:
> > 
> > > 
> > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > 
> > > New Feature: Soft limits for memory resource controller.
> > > 
> > > Here is v9 of the new soft limit implementation. Soft limits is a new feature
> > > for the memory resource controller, something similar has existed in the
> > > group scheduler in the form of shares. The CPU controllers interpretation
> > > of shares is very different though. 
> > >
> > 
> > If there are no objections to these patches, could we pick them up for
> > testing in mmotm. 
> 
> Sorry, I haven't review this patch series. please give me few days.
>

Sure, could you see if the reclaim bits are better now. 

-- 
        Thanks,
	Balbir
