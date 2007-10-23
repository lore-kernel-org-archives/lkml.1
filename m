Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbXJWQEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbXJWQEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 12:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXJWQD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 12:03:58 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:46661 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbXJWQDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 12:03:55 -0400
Date: Tue, 23 Oct 2007 09:00:31 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: mark irqbalance not-recommended
Message-ID: <20071023090031.04a691bb@laptopd505.fenrus.org>
In-Reply-To: <20071023115709.GA1734@elf.ucw.cz>
References: <20071023115709.GA1734@elf.ucw.cz>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2007 13:57:09 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> 
> Mark CONFIG_IRQBALANCE as not recommended any more. It eats too much
> power, and better solutions are available in userspace.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 

Acked-by: Arjan van de Ven <arjan@linux.intel.com>

