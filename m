Return-Path: <linux-kernel-owner+w=401wt.eu-S1754293AbYCCVPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754293AbYCCVPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 16:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761074AbYCCVOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 16:14:53 -0500
Received: from relay2.sgi.com ([192.48.171.30]:52243 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762901AbYCCVOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 16:14:52 -0500
Date: Mon, 3 Mar 2008 13:14:49 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Nick Piggin <npiggin@suse.de>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Eric Dumazet <dada1@cosmosbay.com>,
       netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yanmin_zhang@linux.intel.com, David Miller <davem@davemloft.net>
Subject: Re: [rfc][patch 3/3] use SLAB_ALIGN_SMP
In-Reply-To: <20080303201837.GG8974@wotan.suse.de>
Message-ID: <Pine.LNX.4.64.0803031314390.4131@schroedinger.engr.sgi.com>
References: <20080303093449.GA15091@wotan.suse.de> <20080303093624.GC15091@wotan.suse.de>
 <47CBCAB0.2040604@cosmosbay.com> <20080303124142.GB13138@wotan.suse.de>
 <47CBF683.10201@cosmosbay.com> <20080303134622.GD13138@wotan.suse.de>
 <84144f020803030553s35a40dd8yf88585ccd5a599fd@mail.gmail.com>
 <Pine.LNX.4.64.0803031109200.6917@schroedinger.engr.sgi.com>
 <20080303201008.GD8974@wotan.suse.de> <Pine.LNX.4.64.0803031211100.16049@schroedinger.engr.sgi.com>
 <20080303201837.GG8974@wotan.suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 3 Mar 2008, Nick Piggin wrote:

> They are only crappy in SLUB. In SLAB they are actually useful.

Cannot figure out what you are talking about....
 
