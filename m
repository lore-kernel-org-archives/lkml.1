Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbYDNPib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbYDNPib (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 11:38:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYDNPiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 11:38:22 -0400
Received: from relay2.sgi.com ([192.48.171.30]:42883 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752521AbYDNPiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 11:38:21 -0400
Date: Mon, 14 Apr 2008 10:38:15 -0500
From: Paul Jackson <pj@sgi.com>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       andi@firstfloor.org
Subject: Re: [PATCH 2/2] Customize sched domain via cpuset (v2)
Message-Id: <20080414103815.08e0fdc2.pj@sgi.com>
In-Reply-To: <4802B74D.5040906@jp.fujitsu.com>
References: <47F21BE3.5030705@jp.fujitsu.com>
	<47F5F0BB.1080804@jp.fujitsu.com>
	<1207839195.7074.4.camel@twins>
	<4802B74D.5040906@jp.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H.Seto wrote:
> Paul, could you give me your response?

Ah - sorry.  I was tied up last week and failed to review this
patch in a timely manner.

Yes - this looks good.  Thanks.

Acked-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
