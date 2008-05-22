Return-Path: <linux-kernel-owner+w=401wt.eu-S1758548AbYEVUJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758548AbYEVUJU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 16:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbYEVUJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 16:09:10 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37544 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbYEVUJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 16:09:09 -0400
Subject: Re: fair group scheduler not so fair?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com, mingo@elte.hu,
       pj@sgi.com
In-Reply-To: <4835D14B.20904@nortel.com>
References: <4834B75A.40900@nortel.com> <1211439417.29104.7.camel@twins>
	 <4835D14B.20904@nortel.com>
Content-Type: text/plain
Date: Thu, 22 May 2008 22:07:48 +0200
Message-Id: <1211486868.6463.134.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-22 at 14:02 -0600, Chris Friesen wrote:

> I haven't really dug into the scheduler yet (although that's next), but 
> based on these results it doesn't really look like the load balancer is 
> properly group-aware.

I'm trying, but its turning out to be rather more difficult than
expected. Any help here would be much appreciated.

