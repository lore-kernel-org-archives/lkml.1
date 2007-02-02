Return-Path: <linux-kernel-owner+w=401wt.eu-S1945918AbXBBQSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945918AbXBBQSr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 11:18:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945915AbXBBQSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 11:18:47 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:48109 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945918AbXBBQSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 11:18:47 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Markus Wenke <M.Wenke@web.de>
Subject: Re: Try to fill route cache
Date: Fri, 2 Feb 2007 17:18:42 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <45C08EA6.9070504@web.de> <p73irekogce.fsf@bingen.suse.de> <45C35670.6060406@web.de>
In-Reply-To: <45C35670.6060406@web.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200702021718.43021.dada1@cosmosbay.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 February 2007 16:19, Markus Wenke wrote:
> Andi Kleen schrieb:
> > Markus Wenke <M.Wenke@web.de> writes:
> >> Where is the problem ?
> >
> > pktgen doesn't use the routing cache.
>
> Is there any other chance to test my Application with a stressed route
> cache?
>

I am not sure I understood your stress environment.
Do you use several machines ?
If yes, then the route cache of the destination machine should be filled...

