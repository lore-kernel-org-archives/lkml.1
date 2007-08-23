Return-Path: <linux-kernel-owner+w=401wt.eu-S1757727AbXHWF3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757727AbXHWF3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 01:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750990AbXHWF3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 01:29:22 -0400
Received: from ns.oss.ntt.co.jp ([222.151.198.98]:59366 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbXHWF3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 01:29:21 -0400
Subject: Re: [PATCH] ppc: remove unused amiga_request_irq and
	mach_request_irq
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Linas Vepstas <linas@austin.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070822182859.GX4261@austin.ibm.com>
References: <1187767237.25624.11.camel@sebastian.kern.oss.ntt.co.jp>
	 <18124.1417.743332.974941@cargo.ozlabs.ibm.com>
	 <20070822182859.GX4261@austin.ibm.com>
Content-Type: text/plain; charset=UTF-8
Organization: NTT Open Source Software Center
Date: Thu, 23 Aug 2007 14:29:19 +0900
Message-Id: <1187846959.12759.41.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-08-22 at 13:28 -0500, Linas Vepstas wrote: 
> On Wed, Aug 22, 2007 at 07:44:41PM +1000, Paul Mackerras wrote:
> > Fernando Luis Vázquez Cao writes:
> > 
> > > amiga_request_irq and mach_request_irq are never used, so delete them.
> > 
> > OK, but is there a particular reason you want to do this?
> > 
> > The whole of arch/ppc is going away eventually, so I don't think we
> > need to remove it piece by piece.
> 
> Its often easier to port/move stuff if you clean it up first.
Agreed. It would make things easier for me too.

Fernando

