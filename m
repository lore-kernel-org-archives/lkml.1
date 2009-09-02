Return-Path: <linux-kernel-owner+w=401wt.eu-S1751797AbZIBL0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbZIBL0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 07:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZIBL0S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 07:26:18 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:46810 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbZIBL0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 07:26:18 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [RFC][PATCH 4/8] sched: add smt_gain
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: ego@in.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090902112250.GD3817@in.ibm.com>
References: <20090901083431.748830771@chello.nl>
	 <20090901083826.073345955@chello.nl>  <20090902112250.GD3817@in.ibm.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 13:26:02 +0200
Message-Id: <1251890762.7547.151.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-02 at 16:52 +0530, Gautham R Shenoy wrote:
> > +     .smt_gain               = 1178, /* 15% */       \
> 
> /* 15% of SCHED_LOAD_SCALE */ , I suppose.

Yeah, but that didn't fit on the line.

Also, its +15%, or 115% when pedantic ;-)

