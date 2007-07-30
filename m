Return-Path: <linux-kernel-owner+w=401wt.eu-S966383AbXG3RhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966383AbXG3RhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 13:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761948AbXG3RhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 13:37:06 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:2903 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761732AbXG3RhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 13:37:04 -0400
Date: Mon, 30 Jul 2007 10:50:05 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Michael Buesch <mb@bu3sch.de>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] Use mutex instead of semaphore in the Host AP driver
Message-ID: <20070730145005.GB6586@tuxdriver.com>
References: <20070729212909.GC3432@traven> <20070729213434.GD3432@traven> <200707300006.42397.mb@bu3sch.de> <alpine.LFD.0.999.0707300842350.10861@enigma.security.iitk.ac.in> <alpine.LFD.0.999.0707300904360.10861@enigma.security.iitk.ac.in> <20070730054004.GI3432@traven> <alpine.LFD.0.999.0707301247100.12730@enigma.security.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707301247100.12730@enigma.security.iitk.ac.in>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 30, 2007 at 12:50:31PM +0530, Satyam Sharma wrote:
> 
> 
> On Mon, 30 Jul 2007, Matthias Kaehlcke wrote:
> 
> > [...]
> > 
> > The Host AP driver uses a semaphore as mutex. Use the mutex API
> > instead of the (binary) semaphore.
> > 
> > Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
> 
> Reviewed-by: Satyam Sharma <satyam@infradead.org>

Is that the same as Acked-by?  Or do you disagree with the patch?

Just checkin'...

John
-- 
John W. Linville
linville@tuxdriver.com
