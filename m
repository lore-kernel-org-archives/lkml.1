Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbZILDXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbZILDXT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 23:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZILDXT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 23:23:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:51279 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbZILDXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 23:23:18 -0400
Date: Sat, 12 Sep 2009 05:26:47 +0200
From: Arjan van de Ven <arjan@infradead.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, peterz@infradead.org,
       yanmin_zhang@linux.intel.com, torvalds@linux-foundation.org,
       jens.axboe@oracle.com
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
Message-ID: <20090912052647.3b6dcb78@infradead.org>
In-Reply-To: <20090911220309.GB30989@srcf.ucam.org>
References: <20090911174019.1ed02737@infradead.org>
	<20090911220309.GB30989@srcf.ucam.org>
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

On Fri, 11 Sep 2009 23:03:09 +0100
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> When you say that a bit more power was used, is that instantaneous
> power draw or total power consumption over the run of the benchmark?
> I'd have expected that completing it 50% faster and then going idle
> would be a win overall.

I meant power, not total energy :-)

in terms of energy it's a win if you only do a fixed amount of work...

> 


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
