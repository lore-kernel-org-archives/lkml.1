Return-Path: <linux-kernel-owner+w=401wt.eu-S1762804AbZLLA52@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762804AbZLLA52 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:57:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbZLLA5F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:57:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.25]:54991 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445AbZLLA5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:57:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:message-id:content-type:content-transfer-encoding;
        b=GAkFUlCDhNDZWXSiAi+stjgLEvSPRP06H7JpmhuWrotNitBiYcXOOKiMBRO9ihJQiw
         Nfpkb9guIQPzs4zLSxzFKeaXJo9HGhrLbEejkJLV2537jPvO5KgALHoFg/gSFUTOoOSz
         thbOf7UcKPwZ9SU7xXErve9CG9NN5AML/PCdE=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Con Kolivas <kernel@kolivas.org>
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
Date: Sat, 12 Dec 2009 01:55:39 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: Christoph Lameter <cl@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <200912111124.18118.kernel@kolivas.org> <alpine.DEB.2.00.0912110910490.32415@router.home> <200912120937.42943.kernel@kolivas.org>
In-Reply-To: <200912120937.42943.kernel@kolivas.org>
MIME-Version: 1.0
Message-Id: <200912120155.39197.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 December 2009 11:37:42 pm Con Kolivas wrote:
> On Sat, 12 Dec 2009 02:12:58 Christoph Lameter wrote:
> > On Sat, 12 Dec 2009, Con Kolivas wrote:
> > > On Sat, 12 Dec 2009 01:10:39 Christoph Lameter wrote:
> > > > Could you make the scheduler build time configurable instead of
> > > > replacing the existing one? Embedded folks in particular may love a low
> > > > footprint scheduler.
> > >
> > > It's not a bad idea, but the kernel still needs to be patched either way.
> > > To get BFS they'd need to patch the kernel. If they didn't want BFS, they
> > > wouldn't patch it in the first place.
> > 
> > BFS would have a chance to be merged as an alternate scheduler for
> > specialized situations (such as embedded or desktop use).
> > 
> 
> Nice idea, but regardless of who else might want that, the mainline 

FWIW I would also love to see it happen.

> maintainers have already made it clear they do not.

Oh, those upstream bastards.. ;)

Why do you care so much about their acknowledgment?

If you are not doing your unpaid kernel work for yourself and for people
who recognize/use it then upstream maintainers not liking your changes
should really be the least of your worries..

--
Bartlomiej Zolnierkiewicz
