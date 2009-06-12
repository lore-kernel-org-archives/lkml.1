Return-Path: <linux-kernel-owner+w=401wt.eu-S1761310AbZFLOS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310AbZFLOS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 10:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756592AbZFLOSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 10:18:49 -0400
Received: from smtp3.ultrahosting.com ([74.213.175.254]:35957 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751658AbZFLOSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 10:18:49 -0400
Date: Fri, 12 Jun 2009 10:18:34 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Tejun Heo <tj@kernel.org>
cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Eric Dumazet <dada1@cosmosbay.com>, davem@davemloft.net
Subject: Re: [this_cpu_xx 01/11] Introduce this_cpu_ptr() and generic this_cpu_*
 operations
In-Reply-To: <4A31B8BF.30304@kernel.org>
Message-ID: <alpine.DEB.1.10.0906121017430.13365@gentwo.org>
References: <20090605191819.376530498@gentwo.org> <20090605191850.441840884@gentwo.org> <4A2F40A3.5020602@kernel.org> <alpine.DEB.1.10.0906111109410.29827@gentwo.org> <4A31B8BF.30304@kernel.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Tejun Heo wrote:

> > They are usable for both as the following patches show.
>
> Oops, sorry about that.  Got confused there.  :-)

Reviewed-by's or so would be appreciated. I almost got the allocators
converted to use the ops as well but I want the simple stuff to be merged
first.

