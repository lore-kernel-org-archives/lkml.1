Return-Path: <linux-kernel-owner+w=401wt.eu-S1753190AbZK3Rud@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190AbZK3Rud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:50:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbZK3Ruc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:50:32 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:51889 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbZK3Rub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:50:31 -0500
Date: Mon, 30 Nov 2009 11:50:15 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Tim Blechmann <tim@klingt.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>,
       davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] slab.c: remove branch hint
In-Reply-To: <84144f020911300944x89309c5r8e9079e1a62fb416@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0911301149110.17037@router.home>
References: <cover.1259059549.git.tim@klingt.org> <4B0BBBA8.2090604@klingt.org>  <20091124112058.GA23765@elte.hu>  <84144f020911240328l3d36d347o6c91b2b1a0f50f2a@mail.gmail.com>  <4B125CC2.7000202@klingt.org> <4B138AC2.7080008@cs.helsinki.fi> 
 <alpine.DEB.2.00.0911300926150.14098@router.home> <84144f020911300944x89309c5r8e9079e1a62fb416@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Nov 2009, Pekka Enberg wrote:

> Tim, can you please re-send the patch to me so I can apply it?

SLUB has no issue since NUMA decisions are deferred to the page allocator.


