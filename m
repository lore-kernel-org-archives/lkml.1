Return-Path: <linux-kernel-owner+w=401wt.eu-S933358AbXCUSpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933358AbXCUSpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 14:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933575AbXCUSpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 14:45:14 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36270 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933358AbXCUSpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 14:45:12 -0400
Date: Wed, 21 Mar 2007 11:45:06 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SLAB : Use num_possible_cpus() in enable_cpucache()
In-Reply-To: <4600D756.7070500@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0703211144490.7966@schroedinger.engr.sgi.com>
References: <20070320181235.77d28864.dada1@cosmosbay.com>
 <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org>
 <46005B7D.3090701@cosmosbay.com> <Pine.LNX.4.64.0703201715110.17799@graphe.net>
 <4600D04B.6030305@cosmosbay.com> <4600D756.7070500@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2007, Eric Dumazet wrote:

> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

Acked-by: Christoph Lameter <clameter@sgi.com>
 
