Return-Path: <linux-kernel-owner+w=401wt.eu-S1755358AbYJBTFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358AbYJBTFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753813AbYJBTF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:05:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:55375 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669AbYJBTF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:05:27 -0400
Date: Thu, 2 Oct 2008 12:05:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 01/19] pci: introduce an pci_ioremap(pdev, barnr)
 function
Message-ID: <20081002120521.13053dfa@infradead.org>
In-Reply-To: <200810021153.40722.jbarnes@virtuousgeek.org>
References: <20080928163611.3df8a9e0@infradead.org>
	<200810021153.40722.jbarnes@virtuousgeek.org>
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

On Thu, 2 Oct 2008 11:53:40 -0700
Jesse Barnes <jbarnes@virtuousgeek.org> wrote:

> >
> > Hopefully with this type of API we get less chance of mistakes in
> > drivers with ioremap() operations.
> >
> > Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
> 
> Applied to my linux-next branch, thanks.  I assume you'll have Linus
> pull the driver updates later?

yeah I either need to do an akpm-like "spray the maintainers" or just
do one big pull, haven't figure it out yet
(would be nice if I could just dump the patches on Andrew who then does
the bombard-the-maintainers thing)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
