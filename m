Return-Path: <linux-kernel-owner+w=401wt.eu-S932437AbXBNSrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932437AbXBNSrY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 13:47:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932436AbXBNSrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 13:47:23 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39022 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103AbXBNSrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 13:47:22 -0500
Date: Wed, 14 Feb 2007 10:37:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: eranian@hpl.hp.com
Cc: perfmon@napali.hpl.hp.com, linux-ia64@vger.kernel.org,
       linux-kernel@vger.kernel.org, oprofile-list@lists.sourceforge.net,
       perfctr-devel@lists.sourceforge.net
Subject: Re: 2.6.20 new perfmon code base + libpfm + pfmon
Message-Id: <20070214103743.3cb1c39c.akpm@linux-foundation.org>
In-Reply-To: <20070214182932.GG11681@frankl.hpl.hp.com>
References: <20070213184839.GC10031@frankl.hpl.hp.com>
	<20070213140533.a5ca27ad.akpm@linux-foundation.org>
	<20070214182932.GG11681@frankl.hpl.hp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Feb 2007 10:29:32 -0800
Stephane Eranian <eranian@hpl.hp.com> wrote:

> On Tue, Feb 13, 2007 at 02:05:33PM -0800, Andrew Morton wrote:
> > > On Tue, 13 Feb 2007 10:48:39 -0800 Stephane Eranian <eranian@hpl.hp.com> wrote:
> > > I have released another version of the perfmon new code base package.
> > 
> > Can we have a bug push to get this merged up please?
> 
> Could you please indicate the procedure to do this?

re-post the patches for review-and-possible-integration, as you did last
time, I guess.

> Do you "just" need a patch against your latest -mm tree?

You should only raise patches against -mm is there's a special need to do
that (usually: they're against something which is only in -mm).  Patches
against 2.6.21-rc1 should suit.

