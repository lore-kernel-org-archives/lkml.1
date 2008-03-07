Return-Path: <linux-kernel-owner+w=401wt.eu-S1760731AbYCGRlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760731AbYCGRlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 12:41:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750963AbYCGRlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 12:41:42 -0500
Received: from one.firstfloor.org ([213.235.205.2]:40813 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756786AbYCGRlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 12:41:42 -0500
Date: Fri, 7 Mar 2008 18:43:16 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH] [6/13] Core maskable allocator
Message-ID: <20080307174316.GJ7365@one.firstfloor.org>
References: <200803071007.493903088@firstfloor.org> <20080307090716.9D3E91B419C@basil.firstfloor.org> <20080307090517.b6b27987.randy.dunlap@oracle.com> <20080307173146.GI7365@one.firstfloor.org> <47D17C4E.9000302@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D17C4E.9000302@oracle.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 09:33:02AM -0800, Randy Dunlap wrote:
> Andi Kleen wrote:
> >>>+	maskzone=size[MG] Set size of maskable DMA zone to size.
> >>>+		 force	Always allocate from the mask zone (for testing)
> >>                 ^^^^^^^^^^^^^ ??
> >
> >What is your question?
> 
> That line seems odd.  Is it correct?
> Why 2 spaces between force and Always?  Why is Always capitalized?
> Could one of those words be dropped?  They seem a bit redundant.

The option is either maskzone=size[MG] or maskzone=force
Each followed with a sentence describing them.

I tried to make this clear by lining them up, but apparently failed.
You have a preferred way to formatting such multiple choice options?

-Andi
