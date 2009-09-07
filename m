Return-Path: <linux-kernel-owner+w=401wt.eu-S1753954AbZIGPru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954AbZIGPru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZIGPru
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:47:50 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:56451 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753758AbZIGPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:47:49 -0400
From: Frans Pop <elendil@planet.nl>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and measurements
Date: Mon, 7 Sep 2009 17:47:48 +0200
User-Agent: KMail/1.9.9
Cc: Markus Tornqvist <mjt@nysv.org>, Ingo Molnar <mingo@elte.hu>,
       kernel@kolivas.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de
References: <20090907121613.GA32097@elte.hu> <200909071720.36428.elendil@planet.nl> <20090907083642.5e2b575c@infradead.org>
In-Reply-To: <20090907083642.5e2b575c@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909071747.50825.elendil@planet.nl>
X-OriginalArrivalTime: 07 Sep 2009 15:47:51.0354 (UTC) FILETIME=[8E7AF1A0:01CA2FD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 07 September 2009, Arjan van de Ven wrote:
> it's a shameless plug since I wrote it, but latencytop will be able to
> tell you what your bottleneck is...
> and that is very interesting to know, regardless of the "what scheduler
> code" discussion;

I'm very much aware of that and I've tried pinning it down a few times, 
but failed to come up with anything conclusive. I plan to make a new 
effort in this context as the freezes have increasingly been annoying me.

Unfortunately latencytop only shows a blank screen when used with BFS, but 
I guess that's not totally unexpected.

Cheers,
FJP
