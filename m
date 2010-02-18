Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab0BRTia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 14:38:30 -0500
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:38600 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab0BRTi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 14:38:28 -0500
Date: Thu, 18 Feb 2010 13:37:35 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Adam Litke <agl@us.ibm.com>,
       Avi Kivity <avi@redhat.com>, David Rientjes <rientjes@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 05/12] Memory compaction core
In-Reply-To: <20100216145943.GA997@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1002181335270.7351@router.home>
References: <1265976059-7459-1-git-send-email-mel@csn.ul.ie> <1265976059-7459-6-git-send-email-mel@csn.ul.ie> <20100216170014.7309.A69D9226@jp.fujitsu.com> <20100216084800.GC26086@csn.ul.ie> <alpine.DEB.2.00.1002160849460.18275@router.home>
 <20100216145943.GA997@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010, Mel Gorman wrote:

> > Oh there are numerous ZONE_DMA pressure issues if you have ancient /
> > screwed up hardware that can only operate on DMA or DMA32 memory.
> >
>
> I've never ran into the issue. I was under the impression that the only
> device that might care these days are floopy disks.

Kame-san had an issue a year or so ago.


