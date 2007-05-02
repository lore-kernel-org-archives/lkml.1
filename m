Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbXEBTLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbXEBTLq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 15:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753042AbXEBTLp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 15:11:45 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33979 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754182AbXEBTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 15:11:24 -0400
Date: Wed, 2 May 2007 12:11:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Hugh Dickins <hugh@veritas.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: 2.6.22 -mm merge plans: slub
Message-Id: <20070502121105.de3433d5.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0705021002040.32271@schroedinger.engr.sgi.com>
References: <20070430162007.ad46e153.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705011846590.10660@blonde.wat.veritas.com>
	<20070501125559.9ab42896.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705012101410.26170@blonde.wat.veritas.com>
	<20070501133618.93793687.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0705021346170.16517@blonde.wat.veritas.com>
	<Pine.LNX.4.64.0705021002040.32271@schroedinger.engr.sgi.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 May 2007 10:03:50 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> On Wed, 2 May 2007, Hugh Dickins wrote:
> 
> > But if Linus' tree is to be better than a warehouse to avoid
> > awkward merges, I still think we want it to default to on for
> > all the architectures, and for most if not all -rcs.
> 
> At some point I dream that SLUB could become the default but I thought 
> this would take at least 6 month or so. If want to force this now then I 
> will certainly have some busy weeks ahead.

s/dream/promise/ ;)

Six months sounds reasonable - I was kind of hoping for less.  Make it
default-to-on in 2.6.23-rc1, see how it goes.
