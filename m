Return-Path: <linux-kernel-owner+w=401wt.eu-S1757922AbZAXP6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922AbZAXP6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 10:58:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753259AbZAXP6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 10:58:39 -0500
Received: from casper.infradead.org ([85.118.1.10]:45771 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbZAXP6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 10:58:39 -0500
Date: Sat, 24 Jan 2009 08:01:00 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Peter Hallberg <hallberg68@hotmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: EXTRA_VERSION in #if LINUX_VERSION_CODE >=
 KERNEL_VERSION(x,x,x)
Message-ID: <20090124080100.0843df1a@infradead.org>
In-Reply-To: <BLU122-W7F7E7A4757CD0F4C72C3BDACC0@phx.gbl>
References: <BLU122-W7F7E7A4757CD0F4C72C3BDACC0@phx.gbl>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2009 15:32:06 +0100
Peter Hallberg <hallberg68@hotmail.com> wrote:

> 
> How does one write stuff like
> #if LINUX_VERSION_CODE>= KERNEL_VERSION(2,6,28)
> if the 4 digit EXTRA_VERSION also is needed?u

if you need that something is wrong....

can you be more elaborate in what you're trying to achieve ?

-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
