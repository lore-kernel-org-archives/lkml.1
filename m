Return-Path: <linux-kernel-owner+w=401wt.eu-S1753635AbZIGOlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635AbZIGOlu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 10:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753470AbZIGOlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 10:41:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:45254 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423AbZIGOls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 10:41:48 -0400
Date: Mon, 7 Sep 2009 07:45:07 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Markus Tornqvist <mjt@nysv.org>
Cc: Ingo Molnar <mingo@elte.hu>, mjt@nysv.org, Frans Pop <elendil@planet.nl>,
       kernel@kolivas.org, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, efault@gmx.de
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and
 measurements
Message-ID: <20090907074507.7f00a3ec@infradead.org>
In-Reply-To: <20090907131905.GP28624@nysv.org>
References: <20090907121613.GA32097@elte.hu>
	<20090907131905.GP28624@nysv.org>
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

On Mon, 7 Sep 2009 16:41:51 +0300
> >It shows similar curves and behavior to the 8-core results i posted 
> >- BFS is slower than mainline in virtually every measurement. The 
> >ratios are different for different parts of the graphs - but the 
> >trend is similar.
> 
> Dude, not cool.
> 
> 1. Quad HT is not the same as a 4-core desktop, you're doing it with
> 8 cores 

4 cores, 8 threads. Which is basically the standard desktop cpu going
forward... (4 cores already is today, 8 threads is that any day now)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
