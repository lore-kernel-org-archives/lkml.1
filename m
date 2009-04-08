Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbZDHHhd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbZDHHhd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:37:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760806AbZDHHgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:36:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:53117 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762236AbZDHHgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:36:37 -0400
Subject: Re: Linux 2.6.30-rc1 boot failure on ia64 w/ QLA12160.  Bisected.
From: David Woodhouse <dwmw2@infradead.org>
To: Robin Holt <holt@sgi.com>
Cc: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <1239176024.32073.2.camel@macbook.infradead.org>
References: <alpine.LFD.2.00.0904071700170.4583@localhost.localdomain>
	 <20090408042734.GD10768@sgi.com>
	 <1239176024.32073.2.camel@macbook.infradead.org>
Content-Type: text/plain
Date: Wed, 08 Apr 2009 00:36:29 -0700
Message-Id: <1239176190.32073.3.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 (2.26.0-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-04-08 at 00:33 -0700, David Woodhouse wrote:
> Does this fix it?

Brain fade; don't bother with that one. I think it should be
&fw->data[6] instead.

-- 
dwmw2

