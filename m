Return-Path: <linux-kernel-owner+w=401wt.eu-S1762612AbXEJOZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762612AbXEJOZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 10:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXEJOZe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 10:25:34 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:59021 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750844AbXEJOZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 10:25:33 -0400
Date: Thu, 10 May 2007 10:25:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 06/10] Linux Kernel Markers - Non optimized architectures
Message-ID: <20070510142533.GH22424@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.836290342@polymtl.ca> <20070510065636.GB8019@infradead.org> <20070510131137.GC22424@Krystal> <20070510144039.57f8771b@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070510144039.57f8771b@the-village.bc.nu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 10:23:45 up 97 days,  4:30,  5 users,  load average: 2.47, 3.43, 2.89
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > - Fix optimisation -> optimization typo in powerpc and i386 headers.
> 
> That isn't a typo, it's correct as is.
> 
> Alan

Well, it's correct or not depending on which side of the ocean you are.
but as I used "optimization" everywhere else in my code, I simply try to
be consistent.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
