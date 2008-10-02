Return-Path: <linux-kernel-owner+w=401wt.eu-S1753791AbYJBNGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791AbYJBNGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 09:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753981AbYJBNGj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 09:06:39 -0400
Received: from casper.infradead.org ([85.118.1.10]:60510 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbYJBNGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 09:06:39 -0400
Date: Thu, 2 Oct 2008 06:05:53 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-ID: <20081002060553.3cd32c5c@infradead.org>
In-Reply-To: <20081001215638.3a65134c.akpm@linux-foundation.org>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2008 21:56:38 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 1 Oct 2008 20:00:34 -0700 Arjan van de Ven
> <arjan@infradead.org> wrote:
> 
> > Subject: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
> 
> You proposed this a while back

one year ago to be precise

>and it didn't happen and I forget
> why and the changelog doesn't mention any of that?

Jens didn't like the APi I used back then.
Since then the kernel grew (by Jens) a clean API to do the same...


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
