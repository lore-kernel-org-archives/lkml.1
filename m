Return-Path: <linux-kernel-owner+w=401wt.eu-S1755185AbZJPS6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185AbZJPS6p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 14:58:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754079AbZJPS6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 14:58:44 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:32896 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752962AbZJPS6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 14:58:43 -0400
Date: Fri, 16 Oct 2009 14:50:58 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Mel Gorman <mel@csn.ul.ie>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [this_cpu_xx V6 7/7] this_cpu: slub aggressive use of this_cpu
 operations in the hotpaths
In-Reply-To: <alpine.DEB.1.00.0910161141280.21328@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.10.0910161450110.14329@gentwo.org>
References: <4AD307A5.105@kernel.org> <84144f020910120614r529d8e4em9babe83a90e9371f@mail.gmail.com> <alpine.DEB.1.00.0910130231570.27262@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131041450.21608@gentwo.org> <alpine.DEB.1.10.0910131509170.32394@gentwo.org>
 <4AD4D8B6.6010700@cs.helsinki.fi> <alpine.DEB.1.10.0910131541290.7246@gentwo.org> <alpine.DEB.1.00.0910131305440.3529@chino.kir.corp.google.com> <alpine.DEB.1.10.0910131625370.13756@gentwo.org> <alpine.DEB.1.00.0910131550050.15347@chino.kir.corp.google.com>
 <20091014133457.GB5027@csn.ul.ie> <alpine.DEB.1.00.0910150157250.20184@chino.kir.corp.google.com> <alpine.DEB.1.10.0910161244400.6120@gentwo.org> <alpine.DEB.1.00.0910161141280.21328@chino.kir.corp.google.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Oct 2009, David Rientjes wrote:

> Sure, but it would be even more inexpensive if we can figure out why the
> irqless patch is hanging my netserver machine within the first 60 seconds
> on the TCP_RR benchmark.  I guess nobody else has reproduced that yet.

Nope. Sorry. I have tried running some tests but so far nothing.

