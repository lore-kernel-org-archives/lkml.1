Return-Path: <linux-kernel-owner+w=401wt.eu-S1754387AbXDZKDy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387AbXDZKDy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 06:03:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754536AbXDZKDy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 06:03:54 -0400
Received: from ozlabs.org ([203.10.76.45]:33158 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbXDZKDx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 06:03:53 -0400
Subject: Re: MODULE_MAINTAINER
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Rene Herman <rene.herman@gmail.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@stusta.de>,
       Marcel Holtmann <marcel@holtmann.org>,
       Christoph Hellwig <hch@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070425181856.42fcfeb4.akpm@linux-foundation.org>
References: <46138B4C.2050409@gmail.com>
	 <20070404123311.GA18552@infradead.org> <1175698135.5815.447.camel@violet>
	 <20070404150231.GE27660@stusta.de> <4613C963.6070409@gmail.com>
	 <20070404170016.453d26f1@the-village.bc.nu> <4613D492.2070404@gmail.com>
	 <462C7D74.60003@gmail.com>
	 <1177327476.17026.75.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0704230748270.25463@localhost.localdomain>
	 <462CA764.5080401@gmail.com>
	 <20070425181856.42fcfeb4.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 26 Apr 2007 20:03:28 +1000
Message-Id: <1177581808.30071.50.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-04-25 at 18:18 -0700, Andrew Morton wrote:
> On Mon, 23 Apr 2007 14:32:36 +0200 Rene Herman <rene.herman@gmail.com> wrote:
> 
> > Provide MODULE_MAINTAINER() as a convenient place to stick a name and email 
> 
> I'm not sure we want to do this - that's what ./MAINTAINERS is for and we
> end up having to maintain the same info in two places.

I don't think MAINTAINERS should cover most modules.  But I don't really
mind.

Rusty.


