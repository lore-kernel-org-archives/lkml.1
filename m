Return-Path: <linux-kernel-owner+w=401wt.eu-S1761461AbZLKWhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761461AbZLKWhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 17:37:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761399AbZLKWhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 17:37:35 -0500
Received: from home.kolivas.org ([59.167.196.135]:53529 "EHLO home.kolivas.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761343AbZLKWhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 17:37:33 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Date: Sat, 12 Dec 2009 09:37:42 +1100
User-Agent: KMail/1.12.1 (Linux/2.6.32-ck1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <200912111124.18118.kernel@kolivas.org> <200912120204.51547.kernel@kolivas.org> <alpine.DEB.2.00.0912110910490.32415@router.home>
In-Reply-To: <alpine.DEB.2.00.0912110910490.32415@router.home>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912120937.42943.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009 02:12:58 Christoph Lameter wrote:
> On Sat, 12 Dec 2009, Con Kolivas wrote:
> > On Sat, 12 Dec 2009 01:10:39 Christoph Lameter wrote:
> > > Could you make the scheduler build time configurable instead of
> > > replacing the existing one? Embedded folks in particular may love a low
> > > footprint scheduler.
> >
> > It's not a bad idea, but the kernel still needs to be patched either way.
> > To get BFS they'd need to patch the kernel. If they didn't want BFS, they
> > wouldn't patch it in the first place.
> 
> BFS would have a chance to be merged as an alternate scheduler for
> specialized situations (such as embedded or desktop use).
> 

Nice idea, but regardless of who else might want that, the mainline 
maintainers have already made it clear they do not.

Thanks.
-- 
-ck
