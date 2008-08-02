Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYHBBCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYHBBCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 21:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYHBBCN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 21:02:13 -0400
Received: from wx-out-0506.google.com ([66.249.82.225]:53101 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYHBBCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 21:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=m2cdMwL1VvgJb09Cy+bm9WzLz5qTBWOnDfGh0M9s5k2iIAAarieLoK/+xb6MVEO6CS
         E9FTQSLxH+pZIZcr+2fXb51Hh7ta1AHhDtHxGnBdnmAR0vYRcGczF4HA++VOgqHR34cW
         RsLRtm0b73Jm1SqfzOVuz+EVdKtgSmosJ6P6o=
Message-ID: <82e4877d0808011802i1c220d2dq1da6e929711ff68@mail.gmail.com>
Date: Fri, 1 Aug 2008 21:02:09 -0400
From: "Parag Warudkar" <parag.warudkar@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: 2.6.27-rc1 process time accounting
Cc: linux-kernel@vger.kernel.org, "akpm@osdl.org" <akpm@linux-foundation.org>
In-Reply-To: <1217575828.8157.114.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080731104319.GB5806@ics.muni.cz>
	 <20080731144147.82fcd85e.akpm@linux-foundation.org>
	 <loom.20080801T025718-689@post.gmane.org>
	 <1217575828.8157.114.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2008 at 3:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:

> Can you test with tip/sched/clock ?

-tip from today  seems alright - for the 5 minutes I tested with
x11perf the top shows max CPU usage around 125%.

I assume changes from -tip will flow in mainline sooner or later - if
so this should be sorted out soon.

Parag
