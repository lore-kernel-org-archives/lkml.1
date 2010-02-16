Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab0BPIt1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 03:49:27 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53711 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755909Ab0BPItX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 03:49:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 04/12] Export fragmentation index via /proc/pagetypeinfo
Cc: kosaki.motohiro@jp.fujitsu.com, Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <20100216084113.GB26086@csn.ul.ie>
References: <20100216160518.7303.A69D9226@jp.fujitsu.com> <20100216084113.GB26086@csn.ul.ie>
Message-Id: <20100216174749.7312.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 16 Feb 2010 17:49:20 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Dumb question. I haven't understand why this calculation represent
> > fragmentation index. Do this have theorical background? if yes, can you
> > please tell me the pointer?
> > 
> 
> Yes, there is a theoritical background. It's mostly described in
> 
> http://portal.acm.org/citation.cfm?id=1375634.1375641
> 
> I have a more updated version but it's not published unfortunately.

ok, thanks. I stop to rush dumb question and read it first. I'll resume rest reviewing
few days after.

thanks.


