Return-Path: <linux-kernel-owner+w=401wt.eu-S933872AbZJGBFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933872AbZJGBFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933666AbZJGBFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:05:01 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:59894 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933597AbZJGBFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:05:00 -0400
Date: Tue, 6 Oct 2009 19:39:12 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Rusty Russell <rusty@rustcorp.com.au>
cc: Ingo Molnar <mingo@elte.hu>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Tejun Heo <tj@kernel.org>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [this_cpu_xx V4 01/20] Introduce this_cpu_ptr() and generic
 this_cpu_* operations
In-Reply-To: <200910062034.40864.rusty@rustcorp.com.au>
Message-ID: <alpine.DEB.1.10.0910061937550.3166@gentwo.org>
References: <20091001212521.123389189@gentwo.org> <20091002093453.GA21427@elte.hu> <alpine.DEB.1.10.0910021311440.26189@gentwo.org> <200910062034.40864.rusty@rustcorp.com.au>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Oct 2009, Rusty Russell wrote:

> Does this mean we can kill local.h soon?

Yes if you let me ... Last time Andrew had some concerns so I hid my
patches that remove local.h ;-).



