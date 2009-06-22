Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbZFVNdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbZFVNdq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 09:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751129AbZFVNdi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 09:33:38 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:42825 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbZFVNdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 09:33:38 -0400
Date: Mon, 22 Jun 2009 09:32:13 -0400 (EDT)
From: Tim Abbott <tabbott@ksplice.com>
X-X-Sender: tabbott@vinegar-pot.mit.edu
To: Peter Zijlstra <peterz@infradead.org>
cc: Jon Masters <jonathan@jonmasters.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Anders Kaseorg <andersk@ksplice.com>,
       Jeffrey B Arnold <jbarnold@ksplice.com>,
       "Waseem S. Daher" <wdaher@ksplice.com>
Subject: Re: [PATCH] Add new TAINT_KSPLICE flag for when a Ksplice update
 has been loaded.
In-Reply-To: <1245660614.19816.203.camel@twins>
Message-ID: <alpine.DEB.1.10.0906220928010.26465@vinegar-pot.mit.edu>
References: <alpine.DEB.1.10.0906191422460.29844@vinegar-pot.mit.edu>  <1245442307.16209.66.camel@laptop>  <1245657114.3265.4074.camel@perihelion.bos.jonmasters.org> <1245660614.19816.203.camel@twins>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jun 2009, Peter Zijlstra wrote:

> But without ksplice patches you cannot ksplice, right? That is, there is
> a non trivial patch to the kernel to make this happen afaik. If distros
> ship that, then they can add this taint flag as well. No need to burden
> mainline with any of that until it ksplice proper makes it in.

No, Ksplice can patch completely unmodified upstream and distribution 
kernels.

	-Tim Abbott


