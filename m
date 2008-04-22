Return-Path: <linux-kernel-owner+w=401wt.eu-S1763408AbYDVSAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763408AbYDVSAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 14:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYDVSAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 14:00:12 -0400
Received: from 206-248-169-182.dsl.ncf.ca ([206.248.169.182]:50152 "EHLO
	phobos.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909AbYDVSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 14:00:10 -0400
Date: Tue, 22 Apr 2008 14:00:09 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Sam Ravnborg <sam@ravnborg.org>, akpm@linux-foundation.org,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       kyle@parisc-linux.org, matthew@wil.cx, grundler@parisc-linux.org,
       linux-parisc@vger.kernel.org
Subject: Re: [RFC patch 5/9] PARISC remove -traditional
Message-ID: <20080422180009.GJ19802@phobos.i.cabal.ca>
References: <20080422172404.502954084@polymtl.ca> <20080422172842.036035445@polymtl.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422172842.036035445@polymtl.ca>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2008 at 01:24:09PM -0400, Mathieu Desnoyers wrote:
> Subject: [RFC patch 5/9] Re: [PATCH] Stringify support commas
>  > This is a no-no for those archs that still use -traditional.
>  > > I dunno if this is a problem for you at the moment and the
>  > > right fix is anyway to nuke -traditional.
>  > > 
>  > >     Sam
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Sam Ravnborg <sam@ravnborg.org>
> CC: kyle@parisc-linux.org
> CC: matthew@wil.cx
> CC: grundler@parisc-linux.org
> CC: linux-parisc@vger.kernel.org

no. more work needs to be done to remove it. i have a patch already.

it would likely be smarter to just use a private stringify for the C
code for now.
