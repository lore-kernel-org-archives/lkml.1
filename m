Return-Path: <linux-kernel-owner+w=401wt.eu-S1760156AbYCGReT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760156AbYCGReT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 12:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757250AbYCGReL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 12:34:11 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:24891 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbYCGReK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 12:34:10 -0500
Message-ID: <47D17C4E.9000302@oracle.com>
Date: Fri, 07 Mar 2008 09:33:02 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
References: <200803071007.493903088@firstfloor.org> <20080307090716.9D3E91B419C@basil.firstfloor.org> <20080307090517.b6b27987.randy.dunlap@oracle.com> <20080307173146.GI7365@one.firstfloor.org>
In-Reply-To: <20080307173146.GI7365@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>>> +	maskzone=size[MG] Set size of maskable DMA zone to size.
>>> +		 force	Always allocate from the mask zone (for testing)
>>                  ^^^^^^^^^^^^^ ??
> 
> What is your question?

That line seems odd.  Is it correct?
Why 2 spaces between force and Always?  Why is Always capitalized?
Could one of those words be dropped?  They seem a bit redundant.

-- 
~Randy
