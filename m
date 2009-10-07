Return-Path: <linux-kernel-owner+w=401wt.eu-S1759302AbZJGOaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759302AbZJGOaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759156AbZJGOaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:30:21 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:38126 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758482AbZJGOaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:30:20 -0400
Date: Wed, 7 Oct 2009 10:23:06 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, Mel Gorman <mel@csn.ul.ie>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V5 01/19] Introduce this_cpu_ptr() and generic
 this_cpu_* operations
In-Reply-To: <4ACBD841.1080109@kernel.org>
Message-ID: <alpine.DEB.1.10.0910071022280.5671@gentwo.org>
References: <20091006233654.815079668@gentwo.org> <20091006233729.711197725@gentwo.org> <4ACBD841.1080109@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Oct 2009, Tejun Heo wrote:

> cl@linux-foundation.org wrote:
> > This patch introduces two things: First this_cpu_ptr and then per cpu
> > atomic operations.
>
> percpu#for-next is for the most part a stable tree and 1-12 are
> already in the tree.  Can you please send the changes based on the
> current percpu#for-next?

ok should get to it by the afternoon.

