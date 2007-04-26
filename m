Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbXDZQAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbXDZQAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 12:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754834AbXDZQAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 12:00:50 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:48404 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754832AbXDZQAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 12:00:49 -0400
Date: Thu, 26 Apr 2007 17:00:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rene Herman <rene.herman@gmail.com>
Cc: Adrian Bunk <bunk@stusta.de>, Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_MAINTAINER
Message-ID: <20070426170050.7b333556@the-village.bc.nu>
In-Reply-To: <4630BD61.2050006@gmail.com>
References: <20070404150231.GE27660@stusta.de>
	<4613C963.6070409@gmail.com>
	<20070404170016.453d26f1@the-village.bc.nu>
	<4613D492.2070404@gmail.com>
	<462C7D74.60003@gmail.com>
	<1177327476.17026.75.camel@localhost.localdomain>
	<Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
	<462CA764.5080401@gmail.com>
	<20070425181856.42fcfeb4.akpm@linux-foundation.org>
	<463081E5.5010306@gmail.com>
	<20070426135426.GM3468@stusta.de>
	<4630BD61.2050006@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Tie Alan to his chair and take away his keyboard while we submit patches 
> removing MODULE_AUTHOR? Or just apply a trivial two line, optional, non 
> mandatory, patch introducing a MODULE_MAINTAINER? You pick... :-)

MODULE_AUTHOR is extremely important for licensing enforcement. Removing
it should not be an option.

Alan
