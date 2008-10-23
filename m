Return-Path: <linux-kernel-owner+w=401wt.eu-S1755908AbYJWNRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755908AbYJWNRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 09:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198AbYJWNRK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 09:17:10 -0400
Received: from casper.infradead.org ([85.118.1.10]:57212 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYJWNRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 09:17:09 -0400
Date: Thu, 23 Oct 2008 06:17:19 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] get rid if __cpuinit and __cpuexit
Message-ID: <20081023061719.3ae5b090@infradead.org>
In-Reply-To: <20081023062143.GA2981@x200.localdomain>
References: <20081022153054.335ce51e@infradead.org>
	<20081023062143.GA2981@x200.localdomain>
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

On Thu, 23 Oct 2008 10:21:43 +0400
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> On Wed, Oct 22, 2008 at 03:30:54PM -0700, Arjan van de Ven wrote:
> > Subject: [PATCH] get rid if __cpuinit and __cpuexit
> 
> Aiee!
> 
> Was something said about __devinit/__devexit ?

one at a time ;-)

but seriously, I do want to look at that one too. But it's the last one
on the list, the meminit ones come next as "obscure and complex"


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
