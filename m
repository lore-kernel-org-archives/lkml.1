Return-Path: <linux-kernel-owner+w=401wt.eu-S938560AbXG1ANk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938560AbXG1ANk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 20:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765012AbXG1ANd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 20:13:33 -0400
Received: from waste.org ([66.93.16.53]:39726 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764283AbXG1ANc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 20:13:32 -0400
Date: Fri, 27 Jul 2007 19:12:59 -0500
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ray Lee <ray-lk@madrabbit.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric St-Laurent <ericstl34@sympatico.ca>,
       Rene Herman <rene.herman@gmail.com>,
       Jesper Juhl <jesper.juhl@gmail.com>, ck list <ck@vds.kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, Paul Jackson <pj@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.23
Message-ID: <20070728001259.GJ11166@waste.org>
References: <46A57068.3070701@yahoo.com.au> <2c0942db0707232153j3670ef31kae3907dff1a24cb7@mail.gmail.com> <46A58B49.3050508@yahoo.com.au> <2c0942db0707240915h56e007e3l9110e24a065f2e73@mail.gmail.com> <46A6CC56.6040307@yahoo.com.au> <46A6D7D2.4050708@gmail.com> <1185341449.7105.53.camel@perkele> <46A6E1A1.4010508@yahoo.com.au> <2c0942db0707250909r435fef75sa5cbf8b1c766000b@mail.gmail.com> <20070725215717.df1d2eea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070725215717.df1d2eea.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 09:57:17PM -0700, Andrew Morton wrote:
> So.  We can
> 
> a) provide a way for userspace to reload pagecache and
> 
> b) merge maps2 (once it's finished) (pokes mpm)

Consider me poked, despite not being cc:ed.

-- 
Mathematics is the supreme nostalgia of our time.
