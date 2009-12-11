Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZLKPNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZLKPNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:13:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758394AbZLKPMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:12:54 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:49888 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758206AbZLKPMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:12:54 -0500
Date: Fri, 11 Dec 2009 09:12:58 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Con Kolivas <kernel@kolivas.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: BFS v0.311 CPU scheduler for 2.6.32
In-Reply-To: <200912120204.51547.kernel@kolivas.org>
Message-ID: <alpine.DEB.2.00.0912110910490.32415@router.home>
References: <200912111124.18118.kernel@kolivas.org> <alpine.DEB.2.00.0912110809320.32415@router.home> <200912120204.51547.kernel@kolivas.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Dec 2009, Con Kolivas wrote:

> On Sat, 12 Dec 2009 01:10:39 Christoph Lameter wrote:
> > Could you make the scheduler build time configurable instead of replacing
> > the existing one? Embedded folks in particular may love a low footprint
> > scheduler.
>
> It's not a bad idea, but the kernel still needs to be patched either way. To
> get BFS they'd need to patch the kernel. If they didn't want BFS, they
> wouldn't patch it in the first place.

BFS would have a chance to be merged as an alternate scheduler for
specialized situations (such as embedded or desktop use).



