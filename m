Return-Path: <linux-kernel-owner+w=401wt.eu-S1760709AbXHAIqd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760709AbXHAIqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:46:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbXHAIqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:46:25 -0400
Received: from ns2.suse.de ([195.135.220.15]:47000 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbXHAIqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:46:24 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: [rfc] balance-on-fork NUMA placement
Date: Wed, 1 Aug 2007 10:39:23 +0200
User-Agent: KMail/1.9.6
Cc: Nick Piggin <npiggin@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>
References: <20070731054142.GB11306@wotan.suse.de> <200707311114.09284.ak@suse.de> <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0707311639450.31337@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="ansi_x3.4-1968"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708011039.23356.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 August 2007 01:40:18 Christoph Lameter wrote:
 
> It does in the sense that slabs are allocated following policies. If you 
> want to place individual objects then you need to use kmalloc_node().

Nick wants to place individual objects here

-Andi


