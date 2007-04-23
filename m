Return-Path: <linux-kernel-owner+w=401wt.eu-S1161413AbXDWLZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161413AbXDWLZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 07:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161427AbXDWLZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 07:25:05 -0400
Received: from ozlabs.org ([203.10.76.45]:52810 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161413AbXDWLZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 07:25:03 -0400
Subject: Re: MODULE_MAINTAINER
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rene Herman <rene.herman@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <462C7D74.60003@gmail.com>
References: <46138B4C.2050409@gmail.com>
	 <20070404123311.GA18552@infradead.org>	<1175698135.5815.447.camel@violet>
	 <20070404150231.GE27660@stusta.de>	<4613C963.6070409@gmail.com>
	 <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com>
	 <462C7D74.60003@gmail.com>
Content-Type: text/plain
Date: Mon, 23 Apr 2007 21:24:36 +1000
Message-Id: <1177327476.17026.75.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 11:33 +0200, Rene Herman wrote:
> On 04/04/2007 06:38 PM, Rene Herman wrote:
> 
> Rusty?

Valid points have been made on both sides.  I suggest:

#define MODULE_MAINTAINER(_maintainer) \
	MODULE_AUTHOR("(Maintained by) "_maintainer)

Cheers,
Rusty.


