Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZD1UZB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZD1UZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 16:25:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752475AbZD1UYt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 16:24:49 -0400
Received: from smtp.ultrahosting.com ([74.213.174.254]:35345 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbZD1UYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 16:24:49 -0400
Date: Tue, 28 Apr 2009 16:14:55 -0400 (EDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@qirst.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       jesse.brandeburg@intel.com, netdev@vger.kernel.org, haoki@redhat.com,
       mchan@broadcom.com, davidel@xmailserver.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] poll: Avoid extra wakeups in select/poll
In-Reply-To: <49F76174.6060009@cosmosbay.com>
Message-ID: <alpine.DEB.1.10.0904281612560.13862@qirst.com>
References: <alpine.DEB.1.10.0904241554100.29995@qirst.com> <49F3308B.1030507@cosmosbay.com> <20090426.020411.157511269.davem@davemloft.net> <49F43B8F.2050907@cosmosbay.com> <87ab60rh8t.fsf@basil.nowhere.org> <49F71B63.8010503@cosmosbay.com>
 <alpine.DEB.1.10.0904281501300.13862@qirst.com> <49F76174.6060009@cosmosbay.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Eric Dumazet wrote:

> Part about recvfrom() wakeup avoidance is in David net-2.6 tree, and saves 2 us on udpping here.
>
> Is it what you call git2p1 ?

No that is just the prior version of the poll/select improvements.

Which patch are you referring to?

