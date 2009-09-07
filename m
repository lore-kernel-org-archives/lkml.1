Return-Path: <linux-kernel-owner+w=401wt.eu-S1753616AbZIGOhR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616AbZIGOhR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:37:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753431AbZIGOhR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:37:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:53500 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZIGOhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:37:16 -0400
Date: Mon, 7 Sep 2009 07:40:39 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Nikos Chantziaras <realnc@arcor.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
Message-ID: <20090907074039.1b6bc1ac@infradead.org>
In-Reply-To: <h81v7t$p6e$1@ger.gmane.org>
References: <20090906205952.GA6516@elte.hu>
	<h81v7t$p6e$1@ger.gmane.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Sep 2009 06:38:36 +0300
Nikos Chantziaras <realnc@arcor.de> wrote:

> On 09/06/2009 11:59 PM, Ingo Molnar wrote:
> >[...]
> > Also, i'd like to outline that i agree with the general goals
> > described by you in the BFS announcement - small desktop systems
> > matter more than large systems. We find it critically important
> > that the mainline Linux scheduler performs well on those systems
> > too - and if you (or anyone else) can reproduce suboptimal behavior
> > please let the scheduler folks know so that we can fix/improve it.
> 
> BFS improved behavior of many applications on my Intel Core 2 box in
> a way that can't be benchmarked.  Examples:

Have you tried to see if latencytop catches such latencies ?
