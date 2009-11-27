Return-Path: <linux-kernel-owner+w=401wt.eu-S1752241AbZK0T0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241AbZK0T0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 14:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751674AbZK0T0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 14:26:41 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:40735 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbZK0T0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 14:26:41 -0500
Date: Fri, 27 Nov 2009 13:26:44 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] SLUB: Fix __GFP_ZERO unlikely() annotation
In-Reply-To: <84144f020911261227i3f2c9193v388a7b118402cbb5@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0911271326090.27110@router.home>
References: <1259173279-21220-1-git-send-email-penberg@cs.helsinki.fi>  <1259173636.29779.41.camel@Joe-Laptop.home>  <4B0D77CC.3020807@cs.helsinki.fi>  <alpine.DEB.2.00.0911251414480.4779@router.home>
 <84144f020911261227i3f2c9193v388a7b118402cbb5@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Nov 2009, Pekka Enberg wrote:

> I ran the synthetic benchmarks here and cycle count is roughly the
> same for both versions.

Ok.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

