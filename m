Return-Path: <linux-kernel-owner+w=401wt.eu-S1754721AbYGHUKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721AbYGHUKv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754257AbYGHUKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:10:31 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36480 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbYGHUKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:10:30 -0400
Date: Tue, 8 Jul 2008 16:10:12 -0400
From: Jason Baron <jbaron@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Max Krasnyansky <maxk@qualcomm.com>
Subject: Re: [PATCH 0/3] stop_machine enhancements and simplifications
Message-ID: <20080708201012.GA21567@redhat.com>
References: <200807081750.55536.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807081750.55536.rusty@rustcorp.com.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 08, 2008 at 05:50:55PM +1000, Rusty Russell wrote:
> Hi all,
> 
>    Here are the three stop_machine patches I've queued for the next merge
> window.  The first two are pretty well tested via linux-next, the last is
> recent but fairly straightforward.
> 
>    I'm assuming that Jason and/or Mathieu have need for the ALL_CPUS mod,
> but it can be removed by the last of these patches (left in to reduce
> transition breakage).

hi,

I added the 'ALL_CPUS' feature to support the architecture independent immediate 
code that Mathieu wrote. So, if Mathieu needs it great, otherwise I have no 
other code depending on it.

thanks,

-Jason 
