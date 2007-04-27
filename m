Return-Path: <linux-kernel-owner+w=401wt.eu-S1756039AbXD0QBr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756039AbXD0QBr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 12:01:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756041AbXD0QBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 12:01:46 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37018 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756039AbXD0QBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 12:01:45 -0400
Message-ID: <46321E5E.9010909@redhat.com>
Date: Fri, 27 Apr 2007 12:01:34 -0400
From: Chuck Ebbert <cebbert@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: schwidefsky@de.ibm.com
CC: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-s390@vger.kernel.org, Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 18/38] Improved oops output.
References: <20070427140503.087958775@de.ibm.com>	 <20070427140516.013904506@de.ibm.com>	 <20070427142506.GA12738@infradead.org> <1177687465.23773.2.camel@localhost>
In-Reply-To: <1177687465.23773.2.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Schwidefsky wrote:
>> So we're growing in-kernel disassemblers now? :)
>>
>> I wonder whether this is really worth it, but at least your handwritten
>> one is much nicer than the copy & paste from gdb in the kdb patches.
> 
> The disassembler uses about 8K of memory and it really helps in
> debugging. For me it is worth the cost.
> 

No ksymoops for your architecture?

